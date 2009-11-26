Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZKZHk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZKZHk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZKZHk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:40:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:59477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbZKZHk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:40:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,291,1257148800"; 
   d="scan'208";a="470719842"
From: "Tang, Feng" <feng.tang@intel.com>
To: indexer <indexer@internode.on.net>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 26 Nov 2009 15:40:17 +0800
Subject: RE: [Bug 14658] Regression in efi.c
Thread-Topic: [Bug 14658] Regression in efi.c
Thread-Index: Acpts6f6avInn353Sbu+sJRnDRT1kwAtrE8w
Message-ID: <EADF0A36011179459010BDF5142A457501D006B76C@pdsmsx502.ccr.corp.intel.com>
References: <bug-14658-6666@http.bugzilla.kernel.org/>
	 <200911212017.nALKHLSC029634@demeter.kernel.org>
	 <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>
	 <4B09F685.2080201@internode.on.net>
	 <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>
	 <4B0A6DCA.70805@internode.on.net>  <4B0C7BBE.3040703@internode.on.net>
 <1259110243.7068.8.camel@yhuang-dev.sh.intel.com>
 <4B0CFC10.8050700@internode.on.net>
In-Reply-To: <4B0CFC10.8050700@internode.on.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAQ7fC16025539

William,

You've confirmed that apply commit 772be899b "x86: Make EFI RTC function depend
on 32bit again" right after 7bd867dfb "x86: Move get/set_wallclock to 
x86_platform_ops" will get a bootable kernel.

Then, one debug method may be use "git-rebase -i" to move commit 772be899b right after 
7bd867dfb, and do the bisect from there on. 

Thanks,
Feng
>-----Original Message-----
>From: indexer [mailto:indexer@internode.on.net]
>Sent: 2009Äê11ÔÂ25ÈÕ 17:43
>To: Tang, Feng
>Cc: LKML
>Subject: Re: [Bug 14658] Regression in efi.c
>
>Feng tang
>
>I have just tested and applied that correction, and it resulted in a
>working system. I dont really know where to go from here so any advice
>would be appreciated.
>
>William
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
