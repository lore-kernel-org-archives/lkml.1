Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZGSWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZGSWmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZGSWmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:42:42 -0400
Received: from rtr.ca ([76.10.145.34]:44498 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZGSWml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:42:41 -0400
Message-ID: <4A63A15F.8040804@rtr.ca>
Date: Sun, 19 Jul 2009 18:42:39 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
 	branch
References: <4A631C8F.7000002@rtr.ca> <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com> <4A6337C1.6080104@rtr.ca> <4A63416E.2070103@rtr.ca>
In-Reply-To: <4A63416E.2070103@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
..
> 3. In mythtv-setup -> CaptureCards -> DVB:1 -> RecordingOptions
> there is a tickbox for "Open DVB Card on Demand".  It was ticked,
> so I un-ticked that box.  Everything now works!
> 
> When that tickbox was selected, the xc5000 took five (5) seconds to "open",
> as it did the firmware upload every time.  This appeared to exceed some
> timeout inside myth.
> 
> With the tickbox NOT ticked, myth just opens the tuner once at startup,
> and keeps it open, so no more delay when it wants to use it.
> 
> I wonder if we can be smarter/faster about the xc5000 firmware uploads?
..

The firmware downloads take a little over six seconds, each time,
and appear to be done after any "sleep" of the device.

The "un-ticked checkbox" above means that the device will NEVER
be put to sleep, though..


One problem (not new) remains:  the device remains "live" on the USB
even when the system is powered-off.  It stays quite warm to the touch
and is obviously wasting power this way.

Is there not something the driver could do to put it to sleep
on system shutdown, so that it draws much less power, per USB spec ?

thanks!
