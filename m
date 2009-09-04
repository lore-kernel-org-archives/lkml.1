Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbZIDQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbZIDQSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbZIDQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:18:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbZIDQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:18:11 -0400
Message-ID: <4AA13D0F.6050502@zytor.com>
Date: Fri, 04 Sep 2009 09:15:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Xiao Guangrong <ericxiao.gr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
References: <4A90AADE.20307@gmail.com> <20090829110046.GA6812@elte.hu> <4A997088.60908@zytor.com> <20090831082632.GB15619@elte.hu> <4A9C6ADF.2020707@goop.org> <20090904073355.GA20598@elte.hu> <4AA1369A.5040204@goop.org>
In-Reply-To: <4AA1369A.5040204@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 08:47 AM, Jeremy Fitzhardinge wrote:
> On 09/04/09 00:33, Ingo Molnar wrote:
>>> It hardly seems worth it, but I guess it isn't much code. [...]
>>>     
>> Ok, i understood this as an Acked-by from you - lemme know if that's 
>> wrong ;-)
>>   
> 
> That's a bit proactive.  It's more "Meh-I-suppose-d-by: ".
> 

Pretty much.  I suspect we'll have to undo this when we fix the fixmap,
since it will no longer be adjacent to the vmalloc range.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

