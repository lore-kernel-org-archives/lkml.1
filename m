Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZLCPuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZLCPuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZLCPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:50:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZLCPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:50:51 -0500
Message-ID: <4B17DD4A.2010305@zytor.com>
Date: Thu, 03 Dec 2009 07:46:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Ma, Ling" <ling.ma@intel.com>, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86 platform
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com> <20091126094930.GD32275@elte.hu> <8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com> <20091201021459.43d2142a@infradead.org> <8FED46E8A9CA574792FC7AACAC38FE7714FF5709D9@PDSMSX501.ccr.corp.intel.com> <4B17D3D3.1060502@zytor.com> <20091203153113.GB27324@elte.hu>
In-Reply-To: <20091203153113.GB27324@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 07:31 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 12/03/2009 07:03 AM, Ma, Ling wrote:
>>>> a key question is.. how much more memory do you have free due to -Os?
>>>> (because memory is cache is performance on a system level as well)
>>> The kernel code size from Os is 12M, that from O2 is 14M.
>>>> and how much less icache pressure is there?
>>> From perf stat report, cache reference(unified cache) from O2 is almost the same with Os.
>>
>> The icache pressure was substantially higher (by ~10%) in the reports 
>> that I saw.
> 
> hm, icache numbers are not included in perf stat runs by default. Are 
> there some icache numbers i missed perhaps?
> 

Sorry, you're right; cache references and cache misses.  Furthermore,
I'm wrong, I was looking at references *per unit time*, which just show
that roughly the same number was squeezed into a shorter time.

Never mind me... :-/

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

