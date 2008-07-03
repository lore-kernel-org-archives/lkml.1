Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYGCWvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYGCWvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYGCWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:50:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYGCWu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:50:56 -0400
Message-ID: <486D577B.5040705@zytor.com>
Date: Thu, 03 Jul 2008 15:49:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bernhard Walle <bwalle@suse.de>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make e820_saved have update from setup_data
References: <200807031135.37465.yhlu.kernel@gmail.com>	<200807031137.13984.yhlu.kernel@gmail.com> <20080703230108.1dbe68cb@kopernikus.site>
In-Reply-To: <20080703230108.1dbe68cb@kopernikus.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> [2008-07-03 11:37]:
>> +	/* update the e820_saved too */
>> +	e820_reserve_setup_data();
> 
> Why do you want to update the e820_saved here? /sys/firmware/memmap
> should provide the real BIOS-provided memory map, IMO ...

I would concur with that.

	-hpa
