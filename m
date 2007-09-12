Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbXILVIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbXILVIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762396AbXILVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:06:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:41135 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933503AbXILVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:06:41 -0400
X-Authenticated: #441233
X-Provags-ID: V01U2FsdGVkX19+TC1kiu1+WGVV2spz3yyesW87+4KYRvNJ8rrPqP
	cX1N0JgRN+bY8c
Date: Wed, 12 Sep 2007 23:06:39 +0200
From: Michael Mauch <michael.mauch@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: wake up from a serial port
Message-ID: <20070912210639.GA10172@elmicha>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <200709100831.l8A8VUH6015446@imap1.linux-foundation.org> <20070910132703.2dd92485@the-village.bc.nu> <Pine.LNX.4.60.0709102251250.5200@poirot.grange> <20070911081220.GA20847@flint.arm.linux.org.uk> <Pine.LNX.4.60.0709111217470.19259@poirot.grange> <20070911121057.34b9e066@the-village.bc.nu> <Pine.LNX.4.60.0709122019100.5909@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0709122019100.5909@poirot.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:

> Enable wakeup from serial ports, make it run-time configurable over sysfs, 
> e.g.,
> 
> echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup

Interesting, but how does that work from a user's/hardware perspective?

Do I have to pull DSR/RI to +12V? Can I use one of the other pins to get
these +12V (i.e. a switch and a resistor to shorten these pins is
enough)?

And probably in the BIOS I have to enable "wake on modem ring" (or
something similar)?

Regards...
		Michael
