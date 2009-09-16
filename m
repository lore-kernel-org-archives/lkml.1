Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbZIPVYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbZIPVYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbZIPVYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbZIPVYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:24:43 -0400
Message-ID: <4AB1578B.2040404@redhat.com>
Date: Thu, 17 Sep 2009 00:24:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86 shared msr infrastructure
References: <1253105134-8862-1-git-send-email-avi@redhat.com> <1253105134-8862-4-git-send-email-avi@redhat.com> <20090916212112.GA15550@amt.cnet>
In-Reply-To: <20090916212112.GA15550@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2009 12:21 AM, Marcelo Tosatti wrote:
>> +static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
>>      
> Does this assume the MSRs in question are consistent across CPUs?
>    

Yes.  And they are.

> I guess that is not true with arch_prctl(ARCH_SET_GS/ARCH_GET_GS) ?
>    

These aren't shared MSRs and are saved and restored independently.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

