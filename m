Return-Path: <linux-kernel-owner+w=401wt.eu-S1751335AbYJaLMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbYJaLMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYJaLMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:12:38 -0400
Received: from gw.goop.org ([64.81.55.164]:53653 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYJaLMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:12:38 -0400
Message-ID: <490AE820.1010301@goop.org>
Date: Fri, 31 Oct 2008 22:12:32 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu>
In-Reply-To: <20081031093924.GG30317@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Suresh Siddha wrote:
>>     
>>> We didn't see the lockup in our tests but Xen folks reported similar failures
>>> with their smp call function code.
>>>   
>>>       
>> ...really?  I don't remember anything like that, but perhaps I'm 
>> forgetting something.  In Xen the IPI is sent with a hypercall, 
>> which is definitely a solid enough barrier for these purposes.
>>     
>
> i think Suresh might be referring to some of the fragilities Xen had 
> with generic-ipi. But those AFAICT were due to the on-stack lifetime 
> bug that Nick fixed via the kmalloc? v2.6.26-ish issue.

Right, that's all I could think of.

    J
