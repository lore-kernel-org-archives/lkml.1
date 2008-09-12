Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYILRTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYILRTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYILRS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:18:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28086 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYILRS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:18:58 -0400
Date: Fri, 12 Sep 2008 10:17:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, torvalds@linux-foundation.org
Subject: Re: [path] don't diff generated firmware files
Message-Id: <20080912101742.b3e2ea33.randy.dunlap@oracle.com>
In-Reply-To: <20080901231419.GA5602@x200.localdomain>
References: <20080901150951.5cba4dc7@infradead.org>
	<20080901231419.GA5602@x200.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 03:14:19 +0400 Alexey Dobriyan wrote:

> On Mon, Sep 01, 2008 at 03:09:51PM -0700, Arjan van de Ven wrote:
> > With the new firmware infrastructure in 2.6.27, some files are generated and shouldn't be
> > diffed; add these 2 to the "dontdiff" file
> 
> > --- linux.trees.git/Documentation/dontdiff
> > +++ linux.trees.git/Documentation/dontdiff
> > @@ -5,6 +5,8 @@
> >  *.css
> >  *.dvi
> >  *.eps
> > +*.fw.gen.S
> > +*.fw
> 
> Dontdiff is obsoleted because of .gitignore and should probably be auto-generated
> from them.

Let's please not assume that everyone uses git nor force that.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
