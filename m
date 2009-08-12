Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbZHLRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbZHLRxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZHLRxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:53:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZHLRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:52:59 -0400
Message-ID: <4A83011A.2090808@zytor.com>
Date: Wed, 12 Aug 2009 10:51:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: "Wang, Shane" <shane.wang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [RFC v6][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution	Technology
 support for Linux - Details
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <4A82DBA2.2000509@zytor.com> <037F493892196B458CD3E193E8EBAD4F01EAB641FD@pdsmsx502.ccr.corp.intel.com> <4A82ED93.70705@zytor.com> <4A82EE1E.5080001@linux.intel.com>
In-Reply-To: <4A82EE1E.5080001@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2009 09:30 AM, Arjan van de Ven wrote:
> H. Peter Anvin wrote:
>> On 08/12/2009 08:42 AM, Wang, Shane wrote:
>>> oh, S3 support by TXT is one of TXT support. We have code to secure
>>> S3 sleep and resume.
>>> Without S3 support, TXT code is incomplete.
>>>
>>
>> That doesn't make any sense.
>>
>> The question is: if the user doesn't want S3, do they still need to
>> enable S3 in order to be able to use TXT?  Otherwise, this code needs to
>> be properly conditionalized.
>>
> 
> it's the other way around
> if you have S3 support, you also need the TXT S3 piece.
> the S3 piece of TXT is irrelevant if you cannot do S3.

Right.  Which means the S3 TXT part should be conditionalized on
CONFIG_ACPI_SLEEP.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

