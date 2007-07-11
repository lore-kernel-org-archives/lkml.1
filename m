Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXGKGSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXGKGSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXGKGSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:18:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:53715 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbXGKGSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:18:03 -0400
Message-ID: <46946FB9.5040705@qumranet.com>
Date: Wed, 11 Jul 2007 08:50:49 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com>	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>	 <20070708134850.GB22911@elte.hu>	 <1183937563.6005.365.camel@localhost.localdomain>	 <4691D82F.3030401@qumranet.com>	 <1184029745.6005.402.camel@localhost.localdomain>	 <46931ECB.2060601@qumranet.com> <1184050055.6005.523.camel@localhost.localdomain> <469332F3.1000808@qumranet.com>
In-Reply-To: <469332F3.1000808@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
>> The
>> congruent case which comes to mind is lazy FPU handling.
>>   
>
> That one has preempt_ops in hardware: cr0.ts and #NM.

However, that doesn't handle in-kernel use of the fpu.  
kernel_fpu_begin()/kernel_fpu_end() could easily be modified to take 
advantage of a generic preempt hook.  I'll add a patch for that, and we 
gain preemptible raid-5 parity calculation.


-- 
error compiling committee.c: too many arguments to function

