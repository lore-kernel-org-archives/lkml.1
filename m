Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXD0Ppz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXD0Ppz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXD0Ppz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:45:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50223 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbXD0Ppy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:45:54 -0400
Subject: Re: Video for Linux deprecated drivers (VIDEO_V4L1)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <8355959a0704270809i1de3766elbc54c7ede5f421db@mail.gmail.com>
References: <8355959a0704270809i1de3766elbc54c7ede5f421db@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Apr 2007 12:45:48 -0300
Message-Id: <1177688748.5163.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sunil,

Em Sex, 2007-04-27 às 20:39 +0530, Sunil Naidu escreveu:
> Hello,
> 
> I need add a device for a particular solution on a x86 box. Device is
> Logitech QuickCam, USB based WebCam (has to be included because of the
> change in the experiment specs).
> 
> To get the device working (capture images by a V4L application), need
> to compile the driver (qc-usb) & insert the quickcam.ko module. But,
> what the requirement says I need to enable the VIDEO_V4L1 support.
> Then I need to select USB_QUICKCAM_MESSENGER driver under the V4L USB
> devices. Till here it's fine.
> 
> But if I look at the kernel config, VIDEO_V4L1 is deprecated. If I
> decide to enable VIDEO_V4L1_COMPAT, there isn't any
> USB_QUICKCAM_MESSENGER driver under the V4L USB devices!
> 
> Should I select the VIDEO_V4L1 support to get the WebCam working or is
> there any other way (work around) to get my WebCam working with
> VIDEO_V4L1_COMPAT? Comments pl?

This driver were not yet ported to V4L2. So, if you need it, you will
need to enable VIDEO_V4L1, until someone can port it to V4L2.
 
Cheers,
Mauro

