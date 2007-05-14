Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXENQER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXENQER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXENQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:04:03 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:56217 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbXENQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m9h3i2aUFPTYZd79n4bwIiku1XFBlnjfyGlK/z0VZjxtsJQojJ3Q5Xz5cCCQLPEPb1skZtKZuLxaNmyzi89HUMq+07D+QQH2PPY7LO6k2YF8LGvk3M2Nhns7XFj9QzQR44vjyeDj7CNOb2Mb5FNfrqvKLFhhpaxKGbiUP8pXRgw=
Message-ID: <5486cca80705140904p307138bdx511bf2f186a07221@mail.gmail.com>
Date: Mon, 14 May 2007 18:04:00 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070514172138.1c870793@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	 <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	 <20070514081022.7fcee97f@hyperion.delvare>
	 <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
	 <20070514141437.631fcfd1@hyperion.delvare>
	 <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
	 <20070514172138.1c870793@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean!

2007/5/14, Jean Delvare <khali@linux-fr.org>:

> > Sure. On 2.6.21.1:
> >
> > via686a-isa-6000
> > Adapter: ISA adapter
> > CPU core:  +1.63 V  (min =  +0.06 V, max =  +3.10 V)
> > +2.5V:     +2.45 V  (min =  +0.06 V, max =  +3.10 V)
> > I/O:       +3.52 V  (min =  +3.12 V, max =  +3.45 V)   ALARM
> > +5V:       +5.05 V  (min =  +4.73 V, max =  +5.20 V)
> > +12V:     +12.30 V  (min = +11.35 V, max = +12.48 V)
> > CPU Fan:     0 RPM  (min = 42187 RPM, div = 2)
> > P/S Fan:  2657 RPM  (min = 42187 RPM, div = 2)          ALARM
>
> Hint: increase the fan clock dividers to 4.
>

I've not found an obvious way to set it in sensors.conf. Could you
point me to some doumentation, thanks.

> > while on 2.6.22-rc1:
> >
> > via686a-i2c-9191-6000
> >  ERROR: Can't get adapter or algorithm?!?
>
> Ah, interesting. Could it be that the gnome applet quits because it
> fails to get the adapter name? That wouldn't be very smart, but that's
> possible.

Just for the record. Does not quit. It displays on the panel "Chip not found.".

> This is a side effect of an i2c-core cleanup. This is already fixed in
> lm_sensors 2.10.3 (libsensors.so.3.1.3). Care to give it a try and
> confirm it fixes the problem? Note that it might be a bit tricky to get
> the gnome applet to use your own libsensors rather than the system one.
> You might need to set the LD_LIBRARY_PATH environment variable before
> the applet starts, or something similar.

Luckily the 2.10.3 lm-sensors version is on unstable. The backport to
Debian Etch was straightforward. Now the applet works again! And the
P/S fan indicator (you may have noted that showed 0 in the 2.6.22-rc1
case) works too. Many thanks ;-).

Is this new version required only for the via686 chip or should be a
general advise for Debian Etch users to upgrade to lm-sensors >=
2.10.3 for kernels >= 2.6.22?


    ~ Antonio
