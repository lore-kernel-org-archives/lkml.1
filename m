Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbXKFKtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbXKFKtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXKFKtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:49:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:62670 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbXKFKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Zw87pC8NGBmF2mlw0soA7gzx3nBaOuR22kBaTsMnhLd+oa3Mh/Aq1cA0yrHaKiWD+EMOMFpwk9Qbzhy6xBGMVVrU69y7pmoTq3xoUU8SnpvpHzE4uIg3uymYfyJ+v3oz4yUn7oyKPAVLK6rdOyrST6Ufc+Ti77v+iaADOhUcqCQ=
Message-ID: <47304694.2040904@gmail.com>
Date: Tue, 06 Nov 2007 11:48:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <300725321593711206@pripojeni.net> <20071105234017.fcc10791.akpm@linux-foundation.org>
In-Reply-To: <20071105234017.fcc10791.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Sun, 26 Aug 2007 07:09:02 -0700 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> stk11xx, add a new webcam driver
>>
>> Adds support for stk1125, stk1135 and stkdcnew webcam built-in some
>> notebooks.
> 
> Seem that something in git-dvb (or mainline) broke this driver:
> 
> drivers/media/video/stk11xx-core.c: In function 'show_contrast':
> drivers/media/video/stk11xx-core.c:707: warning: initialization from incompatible pointer type
> drivers/media/video/stk11xx-core.c: In function 'show_whitebalance':
> drivers/media/video/stk11xx-core.c:714: warning: initialization from incompatible pointer type
> drivers/media/video/stk11xx-core.c: In function 'stk11xx_create_sysfs_file':
> drivers/media/video/stk11xx-core.c:727: warning: passing argument 1 of 'class_device_create_file' from incompatible pointer type
> drivers/media/video/stk11xx-core.c: In function 'stk11xx_usb_disconnect':
> drivers/media/video/stk11xx-core.c:851: warning: passing argument 1 of 'class_device_remove_file' from incompatible pointer type
> drivers/media/video/stk11xx-core.c:853: warning: passing argument 1 of 'class_device_remove_file' from incompatible pointer type
> 
> Also, please ask the v4l/dvb guys to look at this driver - there's not a lot
> of point in sending it just to me.

Dvb fellows reviewed it some time ago, but the problem is, that it converts
one color space to another in kernelspace. We are developping an userspace
library for drivers such this one, but it takes longer than I expect. Lets
have it dropped, after the library will be done I'll merge it through v4l tree.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
