Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXCUXPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXCUXPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXCUXPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:15:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44520 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbXCUXPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:15:34 -0400
Date: Wed, 21 Mar 2007 15:59:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: BLK_DEV_MD with CONFIG_NET
Message-Id: <20070321155925.172944e5.randy.dunlap@oracle.com>
In-Reply-To: <20070321120246.GB18195@uranus.ravnborg.org>
References: <20070320200538.5270d636.randy.dunlap@oracle.com>
	<20070320.202621.74740974.davem@davemloft.net>
	<20070321120246.GB18195@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 13:02:46 +0100 Sam Ravnborg wrote:

> On Tue, Mar 20, 2007 at 08:26:21PM -0700, David Miller wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Date: Tue, 20 Mar 2007 20:05:38 -0700
> > 
> > > Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
> > > Unless csum_partial() is built and kept by some arch Makefile,
> > > the result is:
> > > ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > make: *** [modules] Error 2
> > > 
> > > 
> > > Any suggested solutions?
> > 
> > Anything which is every exported to modules, which ought to
> > be the situation in this case, should be obj-y not lib-y
> > right?
> That is also my understanding of lib-y - I should update makefiles.txt
> to reflect this..

I concur, but there seems to be quite a bit of change needed in
Makefile*s for this.  I'll begin with csum_partial() and trying
to use Arnd's suggestion as well.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
