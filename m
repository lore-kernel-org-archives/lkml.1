Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYL0Uty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYL0Uty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYL0Utn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:49:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:50928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbYL0Utn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:49:43 -0500
Message-ID: <495694C5.5000600@kernel.org>
Date: Sat, 27 Dec 2008 12:49:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: clean up setup_clear/force_cpu_cap handling
References: <49509418.6040905@kernel.org> <20081227102234.GD14639@elte.hu>
In-Reply-To: <20081227102234.GD14639@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: fix and cleanup
>>
>> setup_force_cpu_cap() only have one user xen
>> but it should not reuse cleared_cpu_cpus. it will have problem
>> for smp.
>>
>> need to have cpu_cpus_set array too.
>> also need to setup handling before all cpus cap AND
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/cpufeature.h |    4 ++--
>>  arch/x86/include/asm/processor.h  |    3 ++-
>>  arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
>>  3 files changed, 16 insertions(+), 8 deletions(-)
> 
> Rusty, you'll carry this patch in your linux-2.6-boot-params.git tree, 
> right? Merging this in the x86 tree would just needlessly complicate your 
> logistics, right?

Rusty polished this patch a little bit and put the updated one in his tree.
so you may need to pick up the updated one.

YH
