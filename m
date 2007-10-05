Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbXJEVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbXJEVa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763480AbXJEVaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:30:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:55944 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763483AbXJEVaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:30:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18HidctE9UHMffwu3NbWf/ho548SAj1/LukWss53J
	W4Dh1QUKi7nhXB
Date: Fri, 5 Oct 2007 23:30:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Various problems on Axis 700 Lite VIA C7
In-Reply-To: <4706A2F7.8050508@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.60.0710052257140.10392@poirot.grange>
References: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org>
 <Pine.LNX.4.60.0710052215510.10392@poirot.grange> <4706A2F7.8050508@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2007, Michael Tokarev wrote:

[snip]
> That to say - it may be some miscompilations, but may be some probs with
> hardware itself.  If you can, try to reproduce the same on another board
> (I just tried to boot 2.6.23-rc5 on this machine, compiled for PIII CPU
> using gcc-4.1.2 (no other version installed, sorry) - no issues so far).

Hm, well, I could only compile a i686 kernel and Intel chipset with 
"otherwise the same" config with these two compiler options to test... 
Maybe some time. No, I do not have another C7 system.

> And no, I'm not trying to say "don't use ViA C7" etc -- I just love this
> my box, it's very good, powerful enouth and quiet.  Just be prepared for
> some... issues, which happens - rarely but still.

Well, this very system has been running git and compiling kernels for 
itself the whole day today without a single issue. The gcc-3.3.5 
miscompiled kernel was compiled on another machine. So, I hope my specific 
sample is stable. And I need it to be stable, because I'm going to run my 
mail-server on it... BTW, compiled a tickless kernel on it, so far without 
looking into user-space after 12 min uptime 40290 timer interrupts, i.e., 
17Hz, not bad.

As for sensors - my system seems to have a w83627ehf chip, "sensors" 
output (under 2.6.22) looks pretty funny too:

# sensors
w83627ehf-i2c-9191-290
 ERROR: Can't get adapter or algorithm?!?
VCore:     +0.98 V  (min =  +0.00 V, max =  +1.74 V)
in1:      +12.41 V  (min =  +3.17 V, max =  +9.24 V) ALARM
AVCC:      +3.26 V  (min =  +3.82 V, max =  +1.79 V) ALARM
3VCC:      +3.26 V  (min =  +2.86 V, max =  +1.49 V) ALARM
in4:       +1.54 V  (min =  +1.38 V, max =  +1.46 V) ALARM
in5:       +1.59 V  (min =  +2.04 V, max =  +0.95 V) ALARM
in6:       +4.71 V  (min =  +4.48 V, max =  +3.05 V) ALARM
VSB:       +3.26 V  (min =  +4.08 V, max =  +4.08 V) ALARM
VBAT:      +3.20 V  (min =  +3.57 V, max =  +3.02 V) ALARM
in9:       +1.59 V  (min =  +2.04 V, max =  +2.01 V) ALARM
Case Fan:    0 RPM  (min = 3668 RPM, div = 16) ALARM
CPU Fan:     0 RPM  (min = 4440 RPM, div = 16) ALARM
Aux Fan:     0 RPM  (min = 3125 RPM, div = 16) ALARM
fan5:        0 RPM  (min =    0 RPM, div = 8)
Sys Temp:    +39C  (high =    -6C, hyst =    -2C)   ALARM
CPU Temp:  +43.0C  (high = +100.0C, hyst = +95.0C)
AUX Temp:  +42.5C  (high = +100.0C, hyst = +95.0C)

Maybe at least CPU Temp. at least correlates with the real value:-) Yes, 
I'll look in BIOS next time I boot with a connected monitor and a 
keyboard.

Thanks for the info!
Guennadi
---
Guennadi Liakhovetski
