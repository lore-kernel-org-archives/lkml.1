Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYLSRsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYLSRsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYLSRsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:48:36 -0500
Received: from gw.goop.org ([64.81.55.164]:50372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYLSRsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:48:35 -0500
Message-ID: <494BDE71.5010903@goop.org>
Date: Fri, 19 Dec 2008 09:48:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       jbeulich@novell.com, joerg.roedel@amd.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org> <20081218210231.GB24271@elte.hu> <3853A0F2-F817-4263-9EF9-9A0655BF95CD@kernel.crashing.org> <494B46E8.1000104@goop.org> <65BDE147-2DF2-4963-B924-7482DE42D655@kernel.crashing.org>
In-Reply-To: <65BDE147-2DF2-4963-B924-7482DE42D655@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
>
> On Dec 19, 2008, at 1:02 AM, Jeremy Fitzhardinge wrote:
>
>> Becky Bruce wrote:
>>>
>>>
>>> Unfortunately, this is horrible timing for me, as starting tomorrow, 
>>> I'm going to be offline for a week and a half or so in podunk 
>>> Louisiana with essentially no net access.  I can integrate my code 
>>> into your tree and test on PPC as soon as I return to the real world.
>>
>> Yeah, I think that's OK.  The important thing at this point is to 
>> determine whether the two patch sets are aligned or conflicting.  It 
>> sounds like they're largely aligned, and so generating a delta from 
>> my patches to match your needs will be relatively straightforward.
>>
>> I'm trying to line all this Xen stuff up for this merge window, so 
>> I'd prefer to revisit it in the next dev cycle.  Did you want to get 
>> something into this merge window?
>
> I was originally hoping to get something into this merge window, but 
> the timing just isn't working out for me.  The rest of the support is 
> already in the kernel for ppc (actually, most everything is in 
> 2.6.28), and swiotlb is the last bit I need to get this working.   Ah 
> well.... I'll hop to work on this from the ppc point of view as soon 
> as I get back online, and we'll see where that takes us. 


Hm, yes, they're really very similar patch sets.  We can definitely turn 
this into something that will work for both.

    J
