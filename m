Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZEQS5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZEQS5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 14:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZEQS4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 14:56:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZEQS4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 14:56:48 -0400
Message-ID: <4A105BFD.6030309@redhat.com>
Date: Sun, 17 May 2009 21:48:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: kvm replace MSR_IA32_TIME_STAMP_COUNTER with
 MSR_IA32_TSC of msr-index.h
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>	 <1242032701.3114.4.camel@localhost.localdomain>	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>	 <1242279010.4574.6.camel@localhost.localdomain>	 <1242282442.4574.11.camel@localhost.localdomain> <1242393125.3082.4.camel@localhost.localdomain>
In-Reply-To: <1242393125.3082.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> If this patch looks sane to you can apply in kvm tree.
>
> Here is the updated patch based on kvm tree:
>
> [PATCH] x86: kvm replace MSR_IA32_TIME_STAMP_COUNTER with MSR_IA32_TSC of msr-index.h
>
> Use standard msr-index.h's MSR declaration.
>
> MSR_IA32_TSC is better than MSR_IA32_TIME_STAMP_COUNTER as it also solves
> 80 column issue.
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

