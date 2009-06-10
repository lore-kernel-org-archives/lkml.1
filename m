Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZFJSpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZFJSpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZFJSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:44:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbZFJSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:44:51 -0400
Message-ID: <4A2FF1F3.9050009@zytor.com>
Date: Wed, 10 Jun 2009 10:48:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
References: <1242112482.3283.1.camel@localhost.localdomain> <20090512232122.61f2d7c5.akpm@linux-foundation.org> <1244227115.2507.3.camel@ht.satnam> <4A29862D.6030601@zytor.com> <1244262225.2449.22.camel@ht.satnam> <1244652044.3295.10.camel@ht.satnam> <4A2FE9E1.3020705@zytor.com> <20090610174223.GA2697@aftab>
In-Reply-To: <20090610174223.GA2697@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>
>> I'm not really all that doctrinal about this, but I'd like to get a
>> decent answer to the question "where does it stop, *and why*".  It's a
>> slippery slope, and without a target, it goes on forever.
> 
> I still fail to see a real use case which requires adding that info to
> the kernel and querying CPUID directly is _absolutely_ not an option.
> This is what the decisive argument should be and not some "but we have
> already this and that in there." Otherwise its like painting a broken
> car pink - it's still broken.
> 

Exactly, the question is where does it stop *and why* -- give a coherent
argument why drawing a line at any one particular place makes sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

