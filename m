Return-Path: <linux-kernel-owner+w=401wt.eu-S969031AbXGaFCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969031AbXGaFCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968745AbXGaFBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:01:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35810 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965510AbXGaFBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:01:48 -0400
Message-ID: <46AEC245.9060303@us.ibm.com>
Date: Mon, 30 Jul 2007 22:01:57 -0700
From: Badari <pbadari@us.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Joe Jin <joe.jin@oracle.com>
CC: Zach Brown <zach.brown@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com>
In-Reply-To: <20070731043554.GA3393@joejin-pc.cn.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Jin wrote:
>> Hmm.. in this config file, whats causing DIO to panic ? Which test actually
>> passing faulty buffer ?
>>
>>     
>
> By my testing, just defined job3 and job10 will also get the panic, but if
> only have one of them, panic will not appear. the faulty buffer maybe passed
> by mmap.
>   

Thanks. looks lile my machine crashed too while running the tests. I 
will take a look.

Thanks,
Badari

