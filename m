Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZKKH7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZKKH7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbZKKH7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:59:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:46133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747AbZKKH7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,721,1249282800"; 
   d="scan'208";a="512696385"
From: "Ma, Ling" <ling.ma@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 11 Nov 2009 15:57:31 +0800
Subject: RE: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Topic: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Index: AcpinzTPJyk0pFLjQy6kAdaE6SvYpAABPO0A
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FE830400@PDSMSX501.ccr.corp.intel.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu>
 <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
 <20091111071832.GA3156@elte.hu>
In-Reply-To: <20091111071832.GA3156@elte.hu>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAB7xF16002311

Hi Ingo

This program is for 64bit version, so please use 'cc -o memcpy  memcpy.c -O2 -m64'

Thanks
Ling

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: 2009Äê11ÔÂ11ÈÕ 15:19
>To: Ma, Ling
>Cc: H. Peter Anvin; Ingo Molnar; Thomas Gleixner; linux-kernel
>Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast
>string.
>
>
>* Ma, Ling <ling.ma@intel.com> wrote:
>
>> Hi All
>> Please use the memcpy.c(cc -o memcpy memcpy.c -O2) to test more cases,
>> if you have interest. In this program we did simple modification
>> on memcpy_new function.
>
>FYI:
>
>earth4:~/s> cc -o memcpy memcpy.c -O2
>memcpy.c: In function 'do_one_throughput':
>memcpy.c:45: error: impossible register constraint in 'asm'
>memcpy.c:53: error: impossible register constraint in 'asm'
>memcpy.c:47: error: impossible register constraint in 'asm'
>memcpy.c:53: error: impossible register constraint in 'asm'
>
>	Ingo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
