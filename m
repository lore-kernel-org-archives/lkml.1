Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZKBRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZKBRR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZKBRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:17:27 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751042AbZKBRR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:17:26 -0500
Message-ID: <4AEF1424.2030200@sgi.com>
Date: Mon, 02 Nov 2009 09:17:24 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: dimm <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [ RFC, PATCH - 1/2 ] x86-microcode: refactor microcode output
 messages
References: <1257114179.6833.47.camel@dimm> <20091102164621.GF30802@alberich.amd.com>
In-Reply-To: <20091102164621.GF30802@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andreas Herrmann wrote:
> On Sun, Nov 01, 2009 at 11:22:59PM +0100, dimm wrote:
>> Hi,
>>
>>
>> this is in response to Mike's patch "Limit the number of microcode
>> messages".
>>
>> What's about the following (yet preliminary and not thoroughly tested)
>> approach?
> 
> Hmm, patch-1 doesn't apply:
> 
>  patching file arch/x86/include/asm/microcode.h
>  patching file arch/x86/kernel/microcode_amd.c
>  Hunk #1 succeeded at 152 (offset -4 lines).
>  Hunk #2 succeeded at 240 (offset -7 lines).
>  patch: **** malformed patch at line 99: size_t size)
> 
> 
>> patch-1:
>>
>> simplify 'struct ucode_cpu_info' and related operational logic.
>>
>>
>> patch-2: 
>>
>> reduce a number of similar 'microcode version' messages by printing a
>> single message for all cpus with equal microcode version, like:
> 
> Would be useful on systems with many cores.
> 
> On AMD multi-socket systems often you have the same CPU revisions and
> thus you'd like to have similar ucode on all cores. Hence there is a
> high chance that your code would reduce the amount of microcode log
> messages during boot.
> 
> I'd like to test it but would need patches that do apply ...
> 
> 
> Thanks,
> Andreas

I will test it here as well.

Thanks,
Mike
