Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbZENARV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbZENARV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 20:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZENARG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 20:17:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42095 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZENARF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 20:17:05 -0400
Message-ID: <4A0B61B3.5040702@redhat.com>
Date: Thu, 14 May 2009 03:11:31 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Chris Wright <chrisw@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, avi@redhat.com,
       aarcange@redhat.com, mtosatti@redhat.com, hugh@veritas.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com> <1240191366-10029-2-git-send-email-ieidus@redhat.com> <1240191366-10029-3-git-send-email-ieidus@redhat.com> <1240191366-10029-4-git-send-email-ieidus@redhat.com> <1240191366-10029-5-git-send-email-ieidus@redhat.com> <1240191366-10029-6-git-send-email-ieidus@redhat.com> <20090513161739.d801ab67.akpm@linux-foundation.org> <20090513232520.GN12533@x200.localdomain> <4A0B6283.9040106@codemonkey.ws>
In-Reply-To: <4A0B6283.9040106@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Chris Wright wrote:
>> * Andrew Morton (akpm@linux-foundation.org) wrote:
>>  
>>> Breaks ppc64 allmodcofnig because that architecture doesn't export its
>>> copy_user_page() to modules.
>>>     
>>
>> Things like this and updating to use madvise() I think all point towards
>> s/tristate/bool/.  I don't think CONFIG_KSM=M has huge benefit.
>>   
>
> I agree.

I am sending in one sec, the madvise patch that will kick it away from 
being module anyway...

>
> Regards,
>
> Anthony Liguori
>

