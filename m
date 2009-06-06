Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZFFIfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZFFIfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZFFIfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:35:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:19560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZFFIfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:35:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,315,1241420400"; 
   d="scan'208";a="522261915"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 6 Jun 2009 16:37:44 +0800
Subject: RE: linux-next: Tree for June 3 (staging)
Thread-Topic: linux-next: Tree for June 3 (staging)
Thread-Index: AcnmDu2v9tMlN4CXR/2w9AzA6MQqEAActRcg
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A45F4CAC@pdsmsx503.ccr.corp.intel.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
 <20090604175219.GA18605@kroah.com>
 <38D9F46DFF92C54980D2F2C1E8EE313001A45F49F3@pdsmsx503.ccr.corp.intel.com>
 <200906052058.19875.bzolnier@gmail.com>
In-Reply-To: <200906052058.19875.bzolnier@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n568Zn54010880



>-----Original Message-----
>From: Bartlomiej Zolnierkiewicz [mailto:bzolnier@gmail.com]
>Sent: 2009Äê6ÔÂ6ÈÕ 2:58
>To: Gao, Yunpeng
>Cc: Greg KH; Greg KH; linux-kernel@vger.kernel.org
>Subject: Re: linux-next: Tree for June 3 (staging)
>
>On Friday 05 June 2009 05:31:21 Gao, Yunpeng wrote:
>> Hi Greg,
>>
>> Thanks for your quick response.
>>
>> The root cause of the build-errors in ffsport.c is that the kernel block layer
>APIs are different in linux-next tree (.../linux/kernel/git/sfr/linux-next.git)
>than in Linus' kernel tree (.../linux/kernel/git/torvalds/linux-2.6.git).
>>
>> Yesterday, after modify code in ffsport.c to sync up with the block layer APIs
>changes, I have make the kernel against linux-next tree and found no build error
>/ warnings.
>>
>> Then I generated the patch again Linus' kernel tree, tag 'v2.6.30-rc8' and
>sent the patch to you. This patch uses the new block layer APIs and is target
>for the linux-next tree.
>>
>> I guess the below build errors are caused by compiling the patch code in Linus'
>kernel tree. As the block layer API's in Linus' kernel tree is still the old
>one, it'll report this kind of 'implicit declaration of function ...' error.
>I'm sorry for the mis-communication.
>>
>> Now, I'm a bit confused with the process :-) Which git tree should I select
>to generate patch against and submit to? The linux-next tree or Linus' kerner
>tree?
>
>One solution would be to generate the _main_ patch against Linus' tree
>(for Greg to include in staging tree) and then generate _incremental_
>patch with changes to account for block layer API update (for Stephen
>to include in linux-next)..
>
>Thanks.
>Bart

Hi Bart,
Thanks a lot for the good idea. I'll generate the two patches and send them to Greg then.

Thanks.

Rgds,
Yunpeng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
