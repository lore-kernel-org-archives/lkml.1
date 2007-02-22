Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbXBVVD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbXBVVD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBVVD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:03:57 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:52228 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbXBVVD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:03:56 -0500
Message-ID: <45DE0548.5000307@drzeus.cx>
Date: Thu, 22 Feb 2007 22:04:08 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -mm] mmc build fix
References: <200702220619.l1M6JsG7006504@shell0.pdx.osdl.net> <45DDC7F7.6080205@googlemail.com>
In-Reply-To: <45DDC7F7.6080205@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi,
> 
> akpm@linux-foundation.org napisa³(a):
>> The mm snapshot broken-out-2007-02-21-22-18.tar.gz has been uploaded to
>>
>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-21-22-18.tar.gz
>>
>> It contains the following patches against 2.6.21-rc1:
>>
> 
> Possible build fix for
> 
> drivers/built-in.o: In function `mmc_queue_thread':
> /mnt/md0/devel/linux-work5/drivers/mmc/card/queue.c:76: undefined reference to `blk_queue_plugged'
> make: *** [.tmp_vmlinux1] Error 1
> 

Huh? Is blk_queue_plugged() deprecated?


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
