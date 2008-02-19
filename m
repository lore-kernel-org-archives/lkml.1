Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYBSCNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYBSCNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYBSCNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:13:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64680 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbYBSCNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:13:11 -0500
Message-ID: <47BA3ACB.30408@cn.fujitsu.com>
Date: Tue, 19 Feb 2008 10:11:23 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
References: <47B95C4D.6080000@cn.fujitsu.com> <26325.1203357921@turing-police.cc.vt.edu>
In-Reply-To: <26325.1203357921@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Valdis.Kletnieks@vt.edu wrote::
> On Mon, 18 Feb 2008 18:22:05 +0800, Shi Weihua said:
> 
>> -	/*
>> -	 * If we are on the alternate signal stack and would overflow it, don't.
>                                                                    notice this ^
>> -	 * Return an always-bogus address instead so we will die with SIGSEGV.
> 
>> +			 * If we are on the alternate signal stack and would
>> +			 * overflow it, don't return an always-bogus address
>                                 missing here ^
>> +			 * instead so we will die with SIGSEGV.
> 
> "don't. Return" is a vastly different semantic than "don't return".
> 
> I think the same comment error was cut-n-pasted into all 5 patches...
> 

Sorry, it's my mistake.
I will correct the all 5 patches. Thanks.

