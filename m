Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXDTI03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXDTI03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXDTI03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:26:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:45277 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXDTI02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gboyFbQcHogZI2KFLN/rPYxDVGfhQX8i3W6GNNO1P9nl8QGlUq+Di3SfTNAE5i1paFFm/f91ZKC0w0bPUmAF9WfAyZwA5OtDptXyrvCRJsqWVbCBmFX1O095bLvxEMYDkEue0q9oMoiT6b5pxeE/0Xq4WTWEGNyGwPowsy/jG20=
Message-ID: <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
Date: Fri, 20 Apr 2007 10:26:27 +0200
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       edouard.tisserant@wanadoo.fr
In-Reply-To: <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
	 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 20 Apr 2007, Giuseppe Bilotta wrote:
>
> > The first problem is that the usbmouse and usbhid drivers take control
> > of the device, so that when I plug it in the tablet appears as a mouse,
> > with extremely funny effects (cursor jumping around, buttons clicking
> > out of nowhere, and other strange stuff).I have to rmmod usbmouse and
> > usbhid and then re-modprobe acecad to get proper data from the tablet
> > (where by 'proper' I mean that input-events reports apparently correct
> > values for X, Y, pressure and keypresses.
>
> Hi Giuseppe,
>
> could you please send me the product ID of the hardware in question? (you
> could get it for example by running lsusb). Currently the usbhid driver
> blacklists just product ids 0x0004 and 0x0008 (so that for these product
> ids, the HID driver doesn't claim the device and lets other driver -
> acecad - to claim it). I guess you have some newer version of the device,
> so just adding it to blacklist should suffice.

Hello Jiri,

lsusb claims:

Bus 002 Device 003: ID 0460:0004 Ace Cad Enterprise Co., Ltd

and according to hid-core.c this *is* a blacklisted ID ...

-- 
Giuseppe "Oblomov" Bilotta
