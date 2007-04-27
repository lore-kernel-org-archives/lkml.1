Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXD0RQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXD0RQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXD0RQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:16:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36850 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbXD0RPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:15:44 -0400
Date: Fri, 27 Apr 2007 10:17:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
Message-Id: <20070427101722.05cdbae5.randy.dunlap@oracle.com>
In-Reply-To: <1177653822.25885.25.camel@Homer.simpson.net>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
	<20070425120730.4c267c15.akpm@linux-foundation.org>
	<1177529517.6434.29.camel@Homer.simpson.net>
	<20070425203009.GA15917@uranus.ravnborg.org>
	<1177556774.6098.10.camel@Homer.simpson.net>
	<Pine.LNX.4.61.0704270739510.506@yvahk01.tjqt.qr>
	<1177653822.25885.25.camel@Homer.simpson.net>
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

On Fri, 27 Apr 2007 08:03:42 +0200 Mike Galbraith wrote:

> On Fri, 2007-04-27 at 07:40 +0200, Jan Engelhardt wrote:
> > On Apr 26 2007 05:06, Mike Galbraith wrote:
> > >On Wed, 2007-04-25 at 22:30 +0200, Sam Ravnborg wrote:
> > >
> > >> > There are general funnies in the menuconfig world (my preference) here.
> > >> > For instance, I recently had reason to change/test different default IO
> > >> > schedulers, and found that no matter what I did, I couldn't select a
> > >> > default IO scheduler any more, though I used to be able to do so.
> > >
> > >> Tried it now with latest -git from Linus and here it works.
> > >> Notice that you need to make the scheduler a built-in <*>
> > >> before you can select it as default.
> > >> A scheduler selected as a module <M> cannot be made default.
> > >
> > >Ok, I guess my ncurses is ill.  (all built in)  Thanks.
> > 
> > CONFIG_MODULES=n?
> 
> No, I have more modules that you can shake a stick at.
> 
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> CONFIG_MODULE_SRCVERSION_ALL=y

I don't see a menuconfig problem either.
Perhaps posting your full .config would help.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
