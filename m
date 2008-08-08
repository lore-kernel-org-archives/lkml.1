Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbYHHWhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbYHHWhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYHHWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:37:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbYHHWhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:37:20 -0400
Message-ID: <489CC7E2.7040209@zytor.com>
Date: Fri, 08 Aug 2008 15:25:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>	 <489CC246.5000202@zytor.com> <86802c440808081514w3a7ea1d6hda2442e7bf6729a4@mail.gmail.com>
In-Reply-To: <86802c440808081514w3a7ea1d6hda2442e7bf6729a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>> So I'm still clearly missing something about this... if we need sparse IRQs
>> in the first place (which we do), what's the point of the dyn_array?
> 
> x86_64: support CONFIG_HAVE_SPARSE_IRQ and CONFIG_DYN_ARRAY
> x86_32: support CONFIG_DYN_ARRAY
> 
> some arches could use dyn_array with probing nr_irqs and it could be
> 32 and much less than 224.
> some could have that like 512. and those arch may not need to mess up
> with sparse_irq at first point.
> but still could get some flexibilty about that array size.
> 

As an x86 maintainer, I definitely do not want x86-64 and x86-32 to 
diverge unless there is an extremely strong reason to.

Other architectures may speak for themselves, but why not just support 
sparse IRQs on x86-32 *and* -64 and skip the dyn_array variant?

	-=hpa

