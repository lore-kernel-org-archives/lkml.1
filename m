Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYDWGx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYDWGx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYDWGxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:53:48 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:33418 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbYDWGxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:53:47 -0400
Message-ID: <480EDCF5.5000306@bfh.ch>
Date: Wed, 23 Apr 2008 08:53:41 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Francis Moreau <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch>	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>	 <4807635E.9060101@bfh.ch> <4808A09B.6090106@rtr.ca> <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com> <480E6A35.4040108@rtr.ca>
In-Reply-To: <480E6A35.4040108@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2008 06:53:21.0620 (UTC) FILETIME=[B80F6140:01C8A50E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
[snip]
> The earliest IDE drives for Compaq used only CHS sector addressing mode.
> 
> Within four years, though, all new drives had support for the more 
> sensible linear block addressing (LBA) mode, as well.
> 
> LBA has been mandatory in new drives since the early 1990s,
> so there's really no point to CHS addressing any more,
> except when fiddling with MS-DOS style partition tables
> (which have both CHS and LBA values stored inside).

Sorry, can't resist that quip here... Many of the well known x86-based 
OS', OS-installers and even bootloaders from this millenium trusted the 
partition tables c/h/s values to match the bios... causing havoc say 
with PATA drives atached to SATA connectors.

If that weren't the case I guess Linux could have get rid of c/h/s a 
looong time ago. Hmmm... maybe its time?
