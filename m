Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZHLQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZHLQad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZHLQab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:30:31 -0400
Received: from mga10.intel.com ([192.55.52.92]:35599 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754501AbZHLQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,368,1246863600"; 
   d="scan'208";a="716186903"
Message-ID: <4A82EE1E.5080001@linux.intel.com>
Date: Wed, 12 Aug 2009 09:30:22 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
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
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <4A82DBA2.2000509@zytor.com> <037F493892196B458CD3E193E8EBAD4F01EAB641FD@pdsmsx502.ccr.corp.intel.com> <4A82ED93.70705@zytor.com>
In-Reply-To: <4A82ED93.70705@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 08/12/2009 08:42 AM, Wang, Shane wrote:
>> oh, S3 support by TXT is one of TXT support. We have code to secure S3 sleep and resume.
>> Without S3 support, TXT code is incomplete.
>>
> 
> That doesn't make any sense.
> 
> The question is: if the user doesn't want S3, do they still need to
> enable S3 in order to be able to use TXT?  Otherwise, this code needs to
> be properly conditionalized.
> 

it's the other way around
if you have S3 support, you also need the TXT S3 piece.
the S3 piece of TXT is irrelevant if you cannot do S3.
