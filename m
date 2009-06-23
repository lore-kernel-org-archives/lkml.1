Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZFWSt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZFWSt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZFWStu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:49:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZFWStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:49:49 -0400
Message-ID: <4A40F145.7050006@zytor.com>
Date: Tue, 23 Jun 2009 08:14:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Feng Tang <feng.tang@intel.com>, Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com> <20090623072811.GB6397@elte.hu> <20090623154724.08a51ea3@feng-desktop> <20090623080047.GE6397@elte.hu> <20090623160225.1ebb5540@feng-desktop> <20090623080908.GA11181@elte.hu>
In-Reply-To: <20090623080908.GA11181@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Feng Tang <feng.tang@intel.com> wrote:
> 
>> On Tue, 23 Jun 2009 16:00:47 +0800
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> * Feng Tang <feng.tang@intel.com> wrote:
>>>
>>>> For these arch_early_ioremap/arch_early_iounmap API, do you mean 
>>>> we should put it in a sfi.h under "asm" folder? The reason we put 
>>>> it here is to give a arch independent API declaration here and let 
>>>> each arch implement its own func.
>>> Yeah, i'd suggest to create a new early-remap.h and 
>>> early-remap.c kind of file to collect the existing bits for 
>>> that. It's a bit ugly (not really the fault of SFI - these are 
>>> pre-existing facilities) and might need some love - we better 
>>> move it apart so that the light of attention shines on it.
>>>
>>> What's the target merge of the SFI stuff, 2.6.31?
>> AFAIK, Len's target is for 2.6.32
> 
> Ah, ok - then there's time. The code is almost good for .31 btw ;-)
> 

The code is really quite clean; I recommended to Len that he target
2.6.32 not because of the quality of the code, but just to get it plenty
of time to get properly reviewed and any architectural issues getting
fixed properly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

