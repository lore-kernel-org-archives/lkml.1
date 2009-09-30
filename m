Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbZI3Ejt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbZI3Ejt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 00:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZI3Ejt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 00:39:49 -0400
Received: from mga06.intel.com ([134.134.136.21]:57730 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbZI3Ejs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 00:39:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,477,1249282800"; 
   d="scan'208";a="452983190"
Message-ID: <4AC2E103.5090707@linux.intel.com>
Date: Wed, 30 Sep 2009 06:39:31 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mce: rename finished to valid in struct mce
 II
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05CFC.4020702@jp.fujitsu.com> <4AC0FF58.5040302@linux.intel.com> <4AC1C80F.8010904@jp.fujitsu.com> <4AC2926F.4080503@linux.intel.com> <4AC29645.1010209@zytor.com>
In-Reply-To: <4AC29645.1010209@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 09/29/2009 04:04 PM, Andi Kleen wrote:
>> Hidetoshi Seto wrote:
>>> Andi Kleen wrote:
>>>> struct mce is exported to user space. I don't think it's a good idea
>>>> to rename fields in exported structures like this.  That just causes confusion.
>>> I don't know any other real user of this struct than the mcelog and the
>>> mce test suite.  In other words, I expected that you (Huang and Andi) are
>>> only users who may be confused by this kind of change.
>> Also I should add there are other consumers of /dev/mcelog, not just
>> mcelog/mce-inject.
>>
> 
> Details?

e.g. mced

-Andi

