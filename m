Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXGXR75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXGXR75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbXGXR7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:59:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:29933 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbXGXR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:59:48 -0400
Date: Tue, 24 Jul 2007 11:03:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-Id: <20070724110339.9fd0853e.randy.dunlap@oracle.com>
In-Reply-To: <20070724102035.6447565c.randy.dunlap@oracle.com>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
	<46A534EA.6030008@intel.com>
	<46A5C12B.3080904@shadowen.org>
	<20070724021526.3d92286b.akpm@linux-foundation.org>
	<46A5E034.2030205@shadowen.org>
	<Pine.LNX.4.64.0707241849340.18990@fbirervta.pbzchgretzou.qr>
	<20070724102035.6447565c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 10:20:35 -0700 Randy Dunlap wrote:

> On Tue, 24 Jul 2007 18:51:39 +0200 (CEST) Jan Engelhardt wrote:
> 
> > 
> > On Jul 24 2007 12:19, Andy Whitcroft wrote:
> > >>>> if (err) {
> > >>>>     do_something();
> > >>>>     return -ERR;
> > >>>> } else {
> > >>>>     do_somthing_else();
> > >>>> }
> > >>>
> > >>> 	if (err) {
> > >>> 		do_something();
> > >>> 		return -ERR;
> > >>> 	} else
> > >>> 		do_something_else();
> > >> 
> > >> The kool kids on linux-usb-devel largely ended up deciding that the second
> > >> version looks dorky.
> > >
> > >Ok, now if either the preceeding block or following block has {}'s then
> > >we don't report this block for being one line long.  We will miss some
> > >this way, but hey.
> > 
> > As per Ingo Molnar [ http://lkml.org/lkml/2006/9/5/68 ],
> > all blocks in an if-else 'tree' should be {} if there is at least one
> > with more than two statements. (And I do not disagree.)
> 
> You are actually referring to this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
> 
> which did not appear on lkml for review... :(

Oops, I stand corrected (my previous search was based on the patch filename):

http://lkml.org/lkml/2007/5/4/50
or
http://marc.info/?l=linux-kernel&m=117826369817272&w=2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
