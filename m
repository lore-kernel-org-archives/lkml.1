Return-Path: <linux-kernel-owner+w=401wt.eu-S936004AbXGRSEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936004AbXGRSEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935368AbXGRSEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:04:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:59843 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935925AbXGRSE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:04:26 -0400
Message-ID: <469E5628.40609@qumranet.com>
Date: Wed, 18 Jul 2007 21:04:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707181309.11900.caglar@pardus.org.tr> <469DEC04.8000503@qumranet.com> <200707182046.05358.caglar@pardus.org.tr>
In-Reply-To: <200707182046.05358.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 21:04:24 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi Avi;
>
> 18 Tem 2007 Çar tarihinde, Avi Kivity şunları yazmıştı: 
>   
>> This trace is certainly a kvm bug.  What guest are you running?  If it
>> is free (and does not contain private information), can you post it
>> somewhere for me to download?
>>     
>
> After seeing your "[PATCH] i386: Decouple PAE from CONFIG_CMPXCHG64" mail i 
> applied it on top of Linus's current git and disabled HIGHMEM64 (following is 
> the diff between configs)
>
>   

It should not have made any difference.

I'll send you a debug patch tomorrow.  These are rather fundamental
failures, something is seriously wrong.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

