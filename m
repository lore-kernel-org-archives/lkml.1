Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYDWNrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYDWNrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYDWNrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:47:10 -0400
Received: from rtr.ca ([76.10.145.34]:4202 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYDWNrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:47:09 -0400
Message-ID: <480F3DDC.9010906@rtr.ca>
Date: Wed, 23 Apr 2008 09:47:08 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
Cc: Seewer Philippe <philippe.seewer@bfh.ch>, linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch>	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>	 <4807635E.9060101@bfh.ch> <4808A09B.6090106@rtr.ca>	 <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com>	 <480E6A35.4040108@rtr.ca> <38b2ab8a0804230002x4b626fa6p89fe940e8e0ff374@mail.gmail.com>
In-Reply-To: <38b2ab8a0804230002x4b626fa6p89fe940e8e0ff374@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> My last question I promise ;)
> 
> If I'd like to take a look in the kernel code to see where the kernel
> translates an offset
> provided by sys_read into a LBA or CHS address, where should I go ?
..

Two places.  drivers/ide/ide-disk.c :: __ide_do_rw_disk()
and drivers/ata/libata-core.c :: ata_build_rw_tf().

Cheers
