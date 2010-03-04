Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0CDQXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:23:52 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3227 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753845Ab0CDQXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:23:51 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYRMTW-02-KAH-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 17:22:42 +0100
From: Robert Richter <robert.richter@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] oprofile: Convert oprofilefs_lock to raw_spinlock
Message-ID: <20100304162242.GP13205@erda.amd.com>
References: <20100217144121.650660618@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100217144121.650660618@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 16:22:43.0367 (UTC) FILETIME=[EAF24B70:01CABBB6]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.02.10 14:41:59, Thomas Gleixner wrote:
> oprofilefs_lock needs to be a real spinlock on preempt-rt. Convert it
> to a raw_spinlock. No change for !RT kernels.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Robert Richter <robert.richter@amd.com>
> ---
>  arch/arm/oprofile/common.c      |    4 ++--
>  arch/x86/oprofile/nmi_int.c     |    4 ++--
>  drivers/oprofile/event_buffer.c |    4 ++--
>  drivers/oprofile/oprofilefs.c   |    6 +++---
>  include/linux/oprofile.h        |    2 +-
>  5 files changed, 10 insertions(+), 10 deletions(-)

Acked-by: Robert Richter <robert.richter@amd.com>

Thomas, do you want to send it upstream via RT updates?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

