Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXD0Fmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXD0Fmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXD0Fmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:42:44 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41049 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbXD0Fmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:42:42 -0400
Date: Fri, 27 Apr 2007 07:40:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mike Galbraith <efault@gmx.de>
cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
In-Reply-To: <1177556774.6098.10.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.61.0704270739510.506@yvahk01.tjqt.qr>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com> 
 <20070425120730.4c267c15.akpm@linux-foundation.org> 
 <1177529517.6434.29.camel@Homer.simpson.net>  <20070425203009.GA15917@uranus.ravnborg.org>
 <1177556774.6098.10.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 26 2007 05:06, Mike Galbraith wrote:
>On Wed, 2007-04-25 at 22:30 +0200, Sam Ravnborg wrote:
>
>> > There are general funnies in the menuconfig world (my preference) here.
>> > For instance, I recently had reason to change/test different default IO
>> > schedulers, and found that no matter what I did, I couldn't select a
>> > default IO scheduler any more, though I used to be able to do so.
>
>> Tried it now with latest -git from Linus and here it works.
>> Notice that you need to make the scheduler a built-in <*>
>> before you can select it as default.
>> A scheduler selected as a module <M> cannot be made default.
>
>Ok, I guess my ncurses is ill.  (all built in)  Thanks.

CONFIG_MODULES=n?


Jan
-- 
