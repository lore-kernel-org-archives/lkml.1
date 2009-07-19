Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZGSSZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZGSSZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZGSSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:25:10 -0400
Received: from rtr.ca ([76.10.145.34]:37062 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbZGSSZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:25:08 -0400
Message-ID: <4A636503.8030700@rtr.ca>
Date: Sun, 19 Jul 2009 14:25:07 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
 	branch
References: <4A631C8F.7000002@rtr.ca> <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com> <4A63317D.6040208@rtr.ca>
In-Reply-To: <4A63317D.6040208@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
..
> Digital-only, since the tuner stick has never worked (and still doesn't)
> for analog NTSC with MythTV-0.21-fixes.  That's okay, I really only use
> it for digital ATSC over-the-air (OTA) reception.
..

Further to the analog -- which I don't care a whole bunch about --
I did try tracing it through mythtv today.  The mythbackend thread
that dies (segfault) is trying to read audio frames from the
usb-audio device of the 950Q (/dev/dsp1).

It seems to suffer massive stack corruption from something in there,
though I'm not at all sure what the cause might be.
Presumable this same myth code works with other tuners that lack
hardware mpeg encoding, but I don't have any of those here to test with.

I wonder if it's a 64-bit thing?  My mythbox is pure 64-bits.

Cheers
