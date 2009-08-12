Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZHLBZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZHLBZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZHLBZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:25:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264AbZHLBZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:25:30 -0400
Message-ID: <4A821A71.5010401@redhat.com>
Date: Wed, 12 Aug 2009 09:27:13 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'Neil Horman'" <nhorman@redhat.com>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>
Subject: Re: [RFC Patch 1/2] kexec: show memory info in /proc/iomem
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain> <A6AD88C3F2289247BE726C37303E1EB8B3A855AD@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B3A855AD@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu, Fenghua wrote:
>> +
>> +out_free:
>> +	kfree(kexec_free_res);
>> +	kfree(kexec_res);
>> +out_release:
>> +	release_resource(kexec_res);
>> +	goto out;
>> }
>>     
>
> The order of out_free: and out_release: might be reversed. You need to release_resource first; then kfree. Otherwise the previous failures jump to here and will cause problem.
>   

Ahh, sure! I will fix it. Thanks!

