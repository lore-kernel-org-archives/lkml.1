Return-Path: <linux-kernel-owner+w=401wt.eu-S1765824AbZFOTQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765824AbZFOTQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZFOTQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:16:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZFOTQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:16:46 -0400
Message-ID: <4A369E00.2090408@redhat.com>
Date: Mon, 15 Jun 2009 22:16:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>	 <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>	 <20090615171845.GA7664@elte.hu>	 <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>	 <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal>	 <1245091917.6741.185.camel@laptop>  <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop>
In-Reply-To: <1245092561.6741.205.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2009 10:02 PM, Peter Zijlstra wrote:
> Ah, well, I have no idea who expensive cr2 is, if its like a regular
> register then it should be fine. If however its tons more expensive then
> we should really avoid it.
>
>    

IIRC it's pretty cheap, I measured it once when tuning the kvm context 
switch code.  I don't recall the exact numbers.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

