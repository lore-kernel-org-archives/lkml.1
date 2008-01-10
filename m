Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYAJJGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYAJJGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYAJJF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:05:59 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:9094 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYAJJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WzONdavnOj21Ujs9oQ13xkRMmVNcckJa9P1mE0OvvzqGe+lx6uvWq2PVDTRKEZJJRCMqSfRSGPFI3dlIVcv5KD1goaiuz1JQnnieJNSN+OqzPl0i6LPxdU+9W50uiS9yxhuxBNL99xmM2/JRenNwBxk/6wDdXOwpgAkVGnnjbF4=
Message-ID: <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com>
Date: Thu, 10 Jan 2008 10:05:54 +0100
From: Matthew <jackdachef@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <47841C41.4060401@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have been unable to reproduce your problem here, and I notice you have
> the proprietary, highly invasive and closed-source Nvidia driver
> installed in your kernel.
>
> Can you try using the "nv" or "vesa" (unaccelerated) Xorg drivers and
> reproduce the problem that way?
>
> If you *do* reproduce the problem that way, it would be extremely
> helpful if you could enable CONFIG_DEBUG_INFO and provide the vmlinux
> (not vmlinuz/bzImage) file that goes with the crash dump screenshot.
>
> Thanks!

I was able to reproduce it with removed nvidia module (rmmod nvidia) &
nv driver, and will post the pictures later if I find some time (it
was the same function if I recall right)
do you also need: CONFIG_DEBUG_BUGVERBOSE enabled ?

>
>          -hpa
>

Mat
