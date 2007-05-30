Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbXE3JOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbXE3JOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXE3JOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:14:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:54982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbXE3JOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DeRLChPTtNfl6mBEXqBB9sJIwTws22TldvwNPBNl4mLjYz9tt5yE2K2TDTCeOpIVxbW2xdS+AvXe+f5maeU87NeOV+M3EjAqxzWK+zwdKj4/ysS7AhhZIuj6dSsM9qGvHEBMx1l6Rb4Rp92JqVKmHMbxpj/OvBsPHpZr5l1Uj0g=
Message-ID: <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
Date: Wed, 30 May 2007 10:14:31 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>
In-Reply-To: <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <200705210016.20794.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
	 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
	 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/07, Jiri Kosina <jkosina@suse.cz> wrote:
> well I have changed the overall HID code design in 2.6.21 a little bit.
> Anyway, just hardcoding '#define DEBUG' and '#define DEBUG_DATA' (that's
> also important) in 2.6.20-and-older kernels should have similar result as
> CONFIG_HID_DEBUG in post-2.6.21.
>
> In your particular case, the DEBUG_DATA might really be more interesting.

Yup, did both on all drivers/hid/*.c and drivers/usb/input/hid*.c
recompiled and reloaded all modules (hid.ko, usbhid.ko and joydev.ko)

But it's pathetic the fact that ubuntu's kernel have an option
USB_DEBUG and on Makefile is says "if USB_DEBUG; aditional_opt=
-DDEBUG" but inside the files all DEBUG flags are hardcoded undefined.

Also, to turn on KERN_DEBUG messages I saw on kernel hacking webpages:

$ echo 15 15 15 15 > /proc/sys/kernel/printk
$ echo 8 > /proc/sys/kernel/printk

I did it and monitored mesasges and syslog and both shows the same
data... I guess that dump after mouse detection is DEBUG_DATA in
place.

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
