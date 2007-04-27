Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXD0GDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXD0GDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXD0GDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:03:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:60750 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755241AbXD0GDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:03:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185IEgWatI5mNEPjz14aGa/8J++rTidbnyyOtbBaT
	qDjqPraKkesflP
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
From: Mike Galbraith <efault@gmx.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704270739510.506@yvahk01.tjqt.qr>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
	 <20070425120730.4c267c15.akpm@linux-foundation.org>
	 <1177529517.6434.29.camel@Homer.simpson.net>
	 <20070425203009.GA15917@uranus.ravnborg.org>
	 <1177556774.6098.10.camel@Homer.simpson.net>
	 <Pine.LNX.4.61.0704270739510.506@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 08:03:42 +0200
Message-Id: <1177653822.25885.25.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 07:40 +0200, Jan Engelhardt wrote:
> On Apr 26 2007 05:06, Mike Galbraith wrote:
> >On Wed, 2007-04-25 at 22:30 +0200, Sam Ravnborg wrote:
> >
> >> > There are general funnies in the menuconfig world (my preference) here.
> >> > For instance, I recently had reason to change/test different default IO
> >> > schedulers, and found that no matter what I did, I couldn't select a
> >> > default IO scheduler any more, though I used to be able to do so.
> >
> >> Tried it now with latest -git from Linus and here it works.
> >> Notice that you need to make the scheduler a built-in <*>
> >> before you can select it as default.
> >> A scheduler selected as a module <M> cannot be made default.
> >
> >Ok, I guess my ncurses is ill.  (all built in)  Thanks.
> 
> CONFIG_MODULES=n?

No, I have more modules that you can shake a stick at.

CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODULE_SRCVERSION_ALL=y

	-Mike

