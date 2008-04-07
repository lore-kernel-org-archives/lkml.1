Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbYDGW2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbYDGW2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYDGW1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:27:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYDGW1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UGyYQTOQoG5N+kk79OHfzEbLBjjB3ABksB1+Uj64ROIYZhhkgD7+/ZXjdv8M7YPD3v6AIpfN8OuFaYwKqT+i9852Tq0GPj/5jX7jWQvjiYtwGf56u8lU1k94bqmVSHoAdgA3lmh/lmdDc91iiPRK3MKRWdhfR1JAdhrLON7pTdM=
Message-ID: <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>
Date: Tue, 8 Apr 2008 08:27:45 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Gerhard Pircher" <gerhard_pircher@gmx.net>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080406143434.106940@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E82D68.5070305@imap.cc>
	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
	 <47E83D14.8070800@imap.cc>
	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>
	 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
	 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
	 <20080406143434.106940@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 12:34 AM, Gerhard Pircher
<gerhard_pircher@gmx.net> wrote:
> -------- Original-Nachricht --------
>  > Datum: Sun, 6 Apr 2008 17:44:25 +1000
>  > Von: "Dave Airlie" <airlied@gmail.com>
>  > An: "Tilman Schmidt" <tilman@imap.cc>
>  > CC: linux-kernel@vger.kernel.org
>  > Betreff: Re: [2.6.25-rc6] possible regression: X server dying
>
>
>  > >  0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
>  > >  1: [0xb7ef7400]
>  > >  2: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7d8e8]
>  > >  3: /usr/lib/xorg/modules//extensions/libglx.so(DoRender+0xdd)
>  > [0xb7b7645d]
>  > >  4: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7657c]
>  > >  5: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7aa6d]
>  > >  6: /usr/bin/X [0x815809e]
>  > >
>  > >  7: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
>  > >  8: /usr/bin/X(main+0x47e) [0x807717e]
>  > >  9: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7c8bfe0]
>  > >  10: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
>  > >
>  > >  But I know next to nothing about GL, so I'm out of my depth there.
>  > >  I'd welcome any suggestions on how to provoke the crash more
>  > >  regularly so that I could attempt to bisect.
>  >
>  > Its one of the GL screensavers, not sure how to narrow it down, use
>  > ldd to figure out which ones are using GL.
>  >
>  > I've no idea how the kernel is influencing this.
>  >
>  > Dave.
>
>  Sorry for hijacking this thread, but I have a similar problem with the
>  Xorg X server. I'm using kernel 2.6.25-rc8 on my AmigaOne (PowerPC) and
>  the X server dies right on startup, but only if DRI/DRM is enabled.
>  I tested this with both Xorg 7.1 (Debian Etch version) and Xorg 7.2
>  (Lenny). The X server was working fine with kernel 2.6.25-rc6. I have
>  to mention that the AmigaOne uses uncached memory for DMA operations.
>  Benjamin Herrenschmidt fixed DRI recently for non cache coherent systems
>  and his patches are working fine (I applied them to kernel 2.6.25-rc6).
>  Please take a look at the attached Xorg.0.log file or at the excerpt
>  below:

This is not the same problem at all.

So no thread hijacking for you.
.
Dave.
