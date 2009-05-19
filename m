Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZESHQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZESHQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZESHQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:16:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:9772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbZESHQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:16:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,213,1241420400"; 
   d="scan'208";a="144369815"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Tue, 19 May 2009 15:15:44 +0800
Subject: RE: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Thread-Topic: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Thread-Index: AcnYUNXXz5499ZR7SXO/RynnGWuYLgAAGVVg
Message-ID: <4D05DB80B95B23498C72C700BD6C2E0B2EF6E465@pdsmsx502.ccr.corp.intel.com>
References: <20090519125744.4EC3.A69D9226@jp.fujitsu.com>
 <4D05DB80B95B23498C72C700BD6C2E0B2EF6E313@pdsmsx502.ccr.corp.intel.com>
 <20090519141050.4ED5.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090519141050.4ED5.A69D9226@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4J7HflL025128

>>-----Original Message-----
>>From: KOSAKI Motohiro [mailto:kosaki.motohiro@jp.fujitsu.com]
>>Sent: 2009Äê5ÔÂ19ÈÕ 15:10
>>To: Zhang, Yanmin
>>Cc: kosaki.motohiro@jp.fujitsu.com; Wu, Fengguang; LKML; linux-mm; Andrew
>>Morton; Rik van Riel; Christoph Lameter
>>Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
>>
>>Hi
>>
>>> >>> >>Now, it was breaked. What should we do?
>>> >>> >>Yanmin, We know 99% linux people use intel cpu and you are one of
>>> >>> >>most hard repeated testing
>>> >>> [YM] It's very easy to reproduce them on my machines. :) Sometimes, because
>>> >>the
>>> >>> issues only exist on machines with lots of cpu while other community
>>> >>developers
>>> >>> have no such environments.
>>> >>>
>>> >>>
>>> >>>  guy in lkml and you have much test.
>>> >>> >>May I ask your tested machine and benchmark?
>>> >>> [YM] Usually I started lots of benchmark testing against the latest
>>> >>
>>> >>Yeah, that's ok. I and cristoph have. My worries is my unknown workload
>>become
>>> >>regression.
>>> >>so, May I assume you run your benchmark both zonre reclaim 0 and 1 and you
>>> >>haven't seen regression by non-zone reclaim mode?
>>> [YM] what is non-zone reclaim mode? When zone_reclaim_mode=0?
>>> I didn't do that intentionally. Currently I just make sure FIO has a big drop
>>>  when zone_reclaim_mode=1. I might test it with other benchmarks on 2 Nehalem
>>machines.
>>

>>May I ask what is FIO?
>>File IO?
[YM] fio is a tool to test I/O. Jens Axboe is the author.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
