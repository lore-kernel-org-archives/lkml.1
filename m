Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZI2XU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZI2XU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZI2XU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:20:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZI2XU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:20:56 -0400
Message-ID: <4AC29645.1010209@zytor.com>
Date: Tue, 29 Sep 2009 16:20:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mce: rename finished to valid in struct mce
 II
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05CFC.4020702@jp.fujitsu.com> <4AC0FF58.5040302@linux.intel.com> <4AC1C80F.8010904@jp.fujitsu.com> <4AC2926F.4080503@linux.intel.com>
In-Reply-To: <4AC2926F.4080503@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 04:04 PM, Andi Kleen wrote:
> Hidetoshi Seto wrote:
>> Andi Kleen wrote:
>>> struct mce is exported to user space. I don't think it's a good idea
>>> to rename fields in exported structures like this.  That just causes confusion.
>>
>> I don't know any other real user of this struct than the mcelog and the
>> mce test suite.  In other words, I expected that you (Huang and Andi) are
>> only users who may be confused by this kind of change.
> 
> Also I should add there are other consumers of /dev/mcelog, not just
> mcelog/mce-inject.
> 

Details?

	-hpa

