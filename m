Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZDFHgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZDFHgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZDFHgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:36:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbZDFHgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:36:22 -0400
Message-ID: <49D9B031.2090209@redhat.com>
Date: Mon, 06 Apr 2009 10:33:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
References: <1238855722-32606-1-git-send-email-ieidus@redhat.com> <200904061704.50052.nickpiggin@yahoo.com.au>
In-Reply-To: <200904061704.50052.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Sunday 05 April 2009 01:35:18 Izik Eidus wrote:
>
>   
>> This driver is very useful for KVM as in cases of runing multiple guests
>> operation system of the same type.
>> (For desktop work loads we have achived more than x2 memory overcommit
>> (more like x3))
>>     
>
> Interesting that it is a desirable workload to have multiple guests each
> running MS office.
>
> I wonder, can windows enter a paravirtualised guest mode for KVM?

Windows has some support for paravirtualization, for example it can use 
hypercalls instead of tlb flush IPIs.

>  And can
> you detect page allocation/freeing events?
>   

Not that I know of.

-- 
error compiling committee.c: too many arguments to function

