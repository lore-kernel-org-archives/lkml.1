Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYIHPju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYIHPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYIHPjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:39:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYIHPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:39:41 -0400
Message-ID: <48C54704.2040101@zytor.com>
Date: Mon, 08 Sep 2008 08:38:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908152330.GA9784@elte.hu>
In-Reply-To: <20080908152330.GA9784@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> I thought you agreed that CPU virtualization can be a problem? That 
>> was the whole excuse for why the dynamic code was changed. Why would 
>> it not be true for the static code?
>>
>> The fact is, if you want to run on a Core2 or other modern CPU, then 
>> "Virtual PC" is apparently buggy in this respect. You worked around it 
>> for the dynamic choice - but that's totally _pointless_ if you then 
>> don't want to work around it for the static one.
> 
> yes. X86_P6_NOPS is a totally insignificant optimization and if it makes 
> _any_ CPU not boot (be that virtual or real), then it's frankly not 
> worth it.
> 
> David, exactly how does the kernel fail to boot with latest -git? 
> (v2.6.27-rc5-313-g64f996f or later) Does detect_nopl() run? It really 
> should, and it should detect the non-working instructions.
> 

It almost certainly never gets as far as detect_nopl().

	-hpa
