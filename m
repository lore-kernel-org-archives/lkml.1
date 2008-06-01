Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYFAV3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYFAV3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYFAV3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:29:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22583 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbYFAV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pBirog+JPrA1mi9UgFgS56Pb1KieiCiaSWfEroUMxgjBrhFQDrklRQzU7fvoUxjWMYQ6j1/pt0qA89ZSMq8cd5v+UlioLngTnONHqDV3uaD6rcvQDKMfHb1RUIYdwOoSE2AeQJfgUZaOVWd4Ioubbzz47UXFo+bfU89Ol4p3oJw=
Message-ID: <aff5deaf0806011429p2ca2cd46k535ce9c91f2061ec@mail.gmail.com>
Date: Sun, 1 Jun 2008 14:29:15 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: Problem activating multiple cores ONLY if I press any key before kernel is loaded
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080531072535.GD5405@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
	 <20080531072535.GD5405@ucw.cz>
X-Google-Sender-Auth: 6df216aa1f4011b2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, my BIOS doesn't seem to have that option :(. And even if I did,
wouldn't that mean GRUB won't work anyway? Or does GRUB handle USB
keyboards without any BIOS help?

Thanks,
SK

On Sat, May 31, 2008 at 12:25 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sun 2008-05-25 20:39:10, S K wrote:
>> Hi,
>>
>> This is 100% reproducible. I'm using a Shuttle SG33G5, Q9300 (45nm)
>> and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.
>>
>> When the PC boots up, if I don't press any key till I see "Redhat nash
>> version..." everything works fine (well, good enough).
>>
>> But if I press a key during the boot and end up inside GRUB boot menu
>> and choose Linux (Linux is the default), the boot hangs after the line
>> "Booting the kernel." and before "Redhat nash..." is displayed.
>
> USB keyboard? Try disabling usb legacy emulation in bios. If it helps,
> make them fix their bios.
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
