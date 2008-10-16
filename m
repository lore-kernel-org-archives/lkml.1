Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYJPG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYJPG33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYJPG3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:29:21 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:54830 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752397AbYJPG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:29:21 -0400
X-AuditID: ac189297-a8f7dbb000000fe5-2e-48f6df1254ca
Message-ID: <48F6DF22.6070009@alcatel-lucent.com>
Date: Thu, 16 Oct 2008 14:28:50 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: how to limit number of sectors each time
References: <48F6B51B.2000408@alcatel-lucent.com> <20081016054400.GN19428@kernel.dk> <48F6DA7A.9080003@alcatel-lucent.com> <20081016061808.GS19428@kernel.dk> <48F6DD54.70004@alcatel-lucent.com> <20081016062503.GT19428@kernel.dk>
In-Reply-To: <20081016062503.GT19428@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 06:28:37.0994 (UTC) FILETIME=[6C7404A0:01C92F58]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I'm using IDE driver instead of HD driver.
>>     
I dumped out IO registers and PRD table. Note that
maxinum allowed sector number has been decreased
from 256 to 32.

hdc: dma_timer_expiry: dma status == 0x21
========IDE Register DUmp========
DMA start sector: 0x007d5fb5
DMA sectors     : 0x0020
Data Reg        : 0x00
Error Reg       : 0x00
Nsector Reg     : 0x19
Sector Reg      : 0xbc
LCYL Reg        : 0x5f
HCYL Reg        : 0x7d
Select Reg      : 0xe0
Status Reg      : 0x58
Control Reg     : 0x58
IRQ Reg         : 0x58
======Physical Region Descriptor=======
Base_PRD: 0x0189f000  Current_PRD: 0x0189f008  Entries:3
index=0  base=0x00204d1c lengh=0x00100000
index=1  base=0x00604c1c lengh=0x00200000
index=2  base=0x00304d1c lengh=0x00100080

