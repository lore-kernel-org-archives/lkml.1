Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYCUO3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYCUO3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYCUO3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:29:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYCUO3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:29:31 -0400
Date: Fri, 21 Mar 2008 15:29:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080321142919.GD31719@elte.hu>
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080321120313.GD25225@elte.hu> <47E3B335.3020501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3B335.3020501@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>> very nice patch! I always thought that this was the proper way to do 
>> memtest - and we could in fact also do something like this after SMP 
>> bringup, and hit the memory bus via multiple CPUs. [that will need a 
>> different enumeration though than e820 maps]
>>
>> one structural observation: please make this unified functionality, 
>> so that 32-bit kernels can make use of it too.
>>
>
> Indeed.  Of course, it would also be nice if distros shipped 
> bootloader-invoked prekernel test software, like memtest86+, by 
> default.

some do (Fedora for example), but it's still a bit quirky for users to 
invoke and it would be nice to see those results in the kernel log as 
well and flag possibly flaky systems that way. (add a taint bit, etc., 
etc.)

	Ingo
