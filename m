Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZDAIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZDAIHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZDAIH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:07:29 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:6676 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754478AbZDAIHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:07:25 -0400
Message-ID: <49D32041.4090009@panasas.com>
Date: Wed, 01 Apr 2009 11:05:21 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Avishay Traeger <avishay@gmail.com>, open-osd <osd-dev@open-osd.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [osd-dev] [PATCH 6/8] exofs: super_operations and	file_system_type
References: <49C1331D.1080805@panasas.com>	<1237399791-29502-1-git-send-email-bharrosh@panasas.com> <20090331010430.72e8137e.akpm@linux-foundation.org> <49D2665A.9090500@panasas.com>
In-Reply-To: <49D2665A.9090500@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 08:07:19.0823 (UTC) FILETIME=[E11FA9F0:01C9B2A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 09:52 PM, Benny Halevy wrote:
> On Mar. 31, 2009, 11:04 +0300, Andrew Morton <akpm@linux-foundation.org> wrote:
>> ~0 is signed 0xffffffff.
>>
>> When assigning to a u64 it gets signed extended to signed
>> 0xffffffffffffffff and then converted to unsigned 0xffffffffffffffff.
> 
> Right (I think, I'm not sure in what order)
> 
>> I think.  Just as with plain old "-1".  Perhaps using plain old "-1"
>> would be clearer here.
> 
> or maybe ~0ULL or ~(uint64_t)0 to be extremely anal about it.
> 
> Benny
> 

There is only one right way => ULLONG_MAX. Takes care of the human factor
too. (BTW that one is defined (~0ULL))

Thanks
Boaz

