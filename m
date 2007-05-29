Return-Path: <linux-kernel-owner+w=401wt.eu-S1765960AbXE2UMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765960AbXE2UMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765858AbXE2UMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:12:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:19062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374AbXE2UMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MEc2fg+ilM95D7Bbr9Va9KrHo37qolo8Ka4VVY0NBgyqk/2Pd3tD75TJT66MzdkaY1bnn62cwKBLS9bFM4KBguesabh9oHVJBOPZ2K09VL9+wdogeAr7yoREeMVQA+2VHl8L3do1ZLiWfdvsznSLSadQxaw16vaYdvHVszgubHc=
Message-ID: <d120d5000705291312v258a4b40u3886ffec3bedea02@mail.gmail.com>
Date: Tue, 29 May 2007 16:12:32 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Nvidiafb issues on Inspiron 8100
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1180129321.4627.17.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705240137.35955.dtor@insightbb.com>
	 <1180129321.4627.17.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Thu, 2007-05-24 at 01:37 -0400, Dmitry Torokhov wrote:
> > Hi Antonino,
> >
> > I am having the following issues on my Dell Inspiron 8100. They are not
> > new but I just got around to report them.
> >
> > With CONFIG_FB_NVIDIA_I2C I get 1600x1200 resolution but pixels
> > "swarming" and it is unuseable. There are following messages in
> > dmesg (note complaints from i2c):
>
> Looks like an EDID block not accessible by i2c and only available
> through the BIOS. And it's probably broken too.
>
> Can you #define DEBUG in drivers/video/fbmon.c, enable
> CONFIG_FIRMWARE_EDID, the post your dmesg?
>
> For now, the best you can do is disable i2c support and add:
>
> video=nvidiafb:1600x1200@60
>
> in your boot line.

You know, I disabled Nvidia's DDC stuff and enabled firmware EDID
again and it started working fine, even without
video=nvidiafb:1600x1200MR on the command line that I had for a long
time.

So it works fine now. Would you oppode adding dmi check for inspiron
8100 to automatically disable nvidia i2c support at runtime?

-- 
Dmitry
