Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbYB0Wbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbYB0Wbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYB0WbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:31:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64128 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYB0WbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:31:23 -0500
Message-ID: <47C5E4B9.4000901@ct.jp.nec.com>
Date: Wed, 27 Feb 2008 14:31:21 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: X86_HT always enable on X86_64 SMP
References: <47C5D32E.8070308@ct.jp.nec.com>	 <20080227212658.GU29269@cs181133002.pp.htv.fi>	 <47C5D693.3030207@zytor.com> <86802c440802271400k5e981d40vfd278c07c6bf04f5@mail.gmail.com>
In-Reply-To: <86802c440802271400k5e981d40vfd278c07c6bf04f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Feb 27, 2008 at 1:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Adrian Bunk wrote:
>>  > On Wed, Feb 27, 2008 at 01:16:30PM -0800, Hiroshi Shimamoto wrote:
>>  >> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>  >>
>>  >> X86_HT is used for hyperthreading or multicore on 32-bit.
>>  >> The X86_HT on 64-bit is different from 32-bit, it means hyperthreading only.
>>  >> And X86_HT is not used on 64-bit except from cpu/initel_cacheinfo.c.
>>  >>
>>  >> Unify X86_HT for hyperthreading or multicore.
>>  >> Turn X86_HT on when X86_64 and SMP are enabled.
>>  >
>>  > Please fix it properly instead - fiddling around with it the way you do
>>  > only asks for trouble in the future.
>>  >
>>  > What we need are two different variables for:
>>  > - hyperthreading and
>>  > - multicore
>>  >
>>
>>  He does, and calls them SCHED_SMT and SCHED_MC respectively.
>>
>>  It's not particularly clear to me what X86_HT is meant to be used for
>>  anymore at all.
> 
> he made X86_HT can be enabled when only Opteron supported is enabled.

yes on 64-bit. On 32-bit MK8 doesn't affect X86_HT.

