Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXLDMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXLDMER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXLDMED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:04:03 -0500
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:37570 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbXLDMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:04:00 -0500
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [s390] build failure
Cc: elendil@planet.nl, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
In-reply-To: <1196247798.15829.4.camel@localhost>
References: <200711281127.30051.elendil@planet.nl> <1196247798.15829.4.camel@localhost>
Message-Id: <E1IzWVI-0002zO-Ff@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Tue, 04 Dec 2007 13:03:56 +0100
X-OriginalArrivalTime: 04 Dec 2007 12:03:56.0543 (UTC) FILETIME=[BF1838F0:01C8366D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Wed, 2007-11-28 at 11:27 +0100, Frans Pop wrote:
>> arch/s390/kernel/built-in.o: In function `cleanup_io_leave_insn':
>> diag.c:(.text+0xc29a): undefined reference to `preempt_schedule_irq'
>> make[2]: *** [.tmp_vmlinux1] Error 1
> 
> This is fixes by a patch from Christian:
>       [S390] Fix compile error on 31bit without preemption
> 
> You can get the latest s390 patches by pulling from
> git://git390.osdl.marist.edu/pub/scm/linux-2.6.git fixes
 
Any reason this has not been pushed into mainline yet? The fix missed -rc4
because of that...

Cheers,
FJP
