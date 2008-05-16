Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYEPR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYEPR0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYEPR0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:26:24 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:46697 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751433AbYEPR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:26:23 -0400
Message-ID: <482DC3B2.3040907@gawab.com>
Date: Fri, 16 May 2008 10:26:10 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression bisected] HR-timers bug >=2.6.25
References: <482C8FD6.10808@gawab.com>	 <alpine.LFD.1.10.0805160909450.3255@apollo.tec.linutronix.de> <1210922458.7886.14.camel@twins>
In-Reply-To: <1210922458.7886.14.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> The kernel doesn't hang, right? My reading of the description tells me
> the splash just doesn't work.
>
> If it does hang the kernel, an NMI trace collected over serial or
> netconsole (regular console being out of the question since its
> graphical stuff :/) would be most helpful.

I've seen it blank out in 2 different ways.

1) Usplash completely finishes. Then screen goes blank for the usual mode change/screen refreshing,
doing several refreshes of a blank screen. But, the screen then stays black.
I do still hear the gdm sound, and can switch to a console.
Pressing ctrl+alt+f1 makes the screen "refresh" again, but stay blank/black. I can still login but blindly.

2) More rarely. Usplash hasn't finished (but near the end). The usplash screen fades out to black.
It's like a screen burn in, or after image; the screen slowly fades out to black.
After this the computer is _seemingly_unresponsive_ - Only alt+sysrq+b seems to work. (I have to hard reset)
After I reboot the backlight is at the lowest level.

Anyways, I think I can figure out how to set up a netconsole, but
is there something more to setup a NMI trace? I found Documentation/networking/netconsole.txt
But, it doesn't say anything about a NMI trace.

Justin


