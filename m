Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbXFZRTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbXFZRTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbXFZRTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:19:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20261 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbXFZRTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:19:40 -0400
Date: Tue, 26 Jun 2007 10:19:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arne Georg Gleditsch <argggh@dolphinics.no>
Cc: Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-Id: <20070626101958.1cf6c6ae.randy.dunlap@oracle.com>
In-Reply-To: <87645bhtvw.fsf@pelargir.dolphinics.no>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
	<20070623104303.a186c5a8.randy.dunlap@oracle.com>
	<87645bhtvw.fsf@pelargir.dolphinics.no>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 12:50:27 +0200 Arne Georg Gleditsch wrote:

> Randy Dunlap <randy.dunlap@oracle.com> writes:
> > OTOH, you also didn't supply a patch.  If you do this, I'll be
> > glad to consider it.  If I can read it, that is.
> 
> I like bash as much as the next guy, but (to my surprise) /bin/sh on
> my current workstation is actually dash.  How about just replacing the
> substring-interpolations with:
> 
> if [ $marker -ne 0 ]; then
> 	beforemark=`echo "$code" | cut -c-$((marker - 1))`
> [..]
> # and fix code at-and-after marker
> 	code=`echo "$code" | cut -c$marker-`
> fi
> 
> and be done with it?


Are these 2 line changes all that is needed?

I sort of expected expressions like $((a + 2)) to need change also...
maybe not for dash, but for sh?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
