Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbYB0VoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbYB0VoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYB0VoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:44:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYB0VoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:44:13 -0500
Message-ID: <47C5D693.3030207@zytor.com>
Date: Wed, 27 Feb 2008 13:30:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: X86_HT always enable on X86_64 SMP
References: <47C5D32E.8070308@ct.jp.nec.com> <20080227212658.GU29269@cs181133002.pp.htv.fi>
In-Reply-To: <20080227212658.GU29269@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Feb 27, 2008 at 01:16:30PM -0800, Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> X86_HT is used for hyperthreading or multicore on 32-bit.
>> The X86_HT on 64-bit is different from 32-bit, it means hyperthreading only.
>> And X86_HT is not used on 64-bit except from cpu/initel_cacheinfo.c.
>>
>> Unify X86_HT for hyperthreading or multicore.
>> Turn X86_HT on when X86_64 and SMP are enabled.
> 
> Please fix it properly instead - fiddling around with it the way you do
> only asks for trouble in the future.
> 
> What we need are two different variables for:
> - hyperthreading and
> - multicore
> 

He does, and calls them SCHED_SMT and SCHED_MC respectively.

It's not particularly clear to me what X86_HT is meant to be used for 
anymore at all.

	-hpa
