Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYBBNBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYBBNBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYBBNBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:01:31 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:53731 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbYBBNBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:01:30 -0500
Date: Sat, 02 Feb 2008 14:01:27 +0100
Message-Id: <141139231@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [clocksource] jiffies as clocksource kills box
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19t/ugoSE8bC3yoifC6wsOLWT3YPhH9IsuPX2RMKsHDRd1Is
 jcsqzMkQqVcL2G5mDQX28Jk6+ffhxnXy+GsZZPrjuriybVkBEs=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I have a patch pending for the PIT issue. Will add jiffies to this as
>well.

yes, please. 
while trying to analyze a timer issue and learning about that timer stuff, i "killed" my box twice because i didn`t know that "echo jiffies|pit > current_clocksource" is a no-no with dynticks.
this happened with vendor kernel and thought i hit a bug, so i tried vanilla but.....same issue.

not a big one, but that patch would be a time-saver for those who don`t know...

roland


>> Per $subject, echo jiffies > current_clocksource pretty thoroughly kills
>> my P4 box, and does so with every kernel I have (2.6.22->present).  I
>> can drive the box via mouse clicks and poke around, but trying to select
>> another clocksource thereafter is nogo.. cat current_clocksource emits
>> jiffies, and box remains comatose unless prodded.
>
>I guess your box has high resolution timers and/or dynamic ticks
>enabled. In that case we really can not switch to jiffies. We also
>have to prevent PIT from being selected. 
>
>I have a patch pending for the PIT issue. Will add jiffies to this as
>well.
>
>We'll fix that in .25 as it requires root user interaction and does
>not show up magically.
>
>Thanks,
>	tglx
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

