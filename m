Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbXGaTLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbXGaTLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXGaTLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:11:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57571 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXGaTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:11:19 -0400
Date: Tue, 31 Jul 2007 21:11:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Introduce U16_MAX and U32_MAX
In-Reply-To: <20070731115729.64c875d4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707312110090.22515@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707312153500.28746@enigma.security.iitk.ac.in>
 <20070731115729.64c875d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 31 2007 11:57, Andrew Morton wrote:
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -30,6 +30,9 @@ extern const char linux_proc_banner[];
>>  #define LLONG_MIN	(-LLONG_MAX - 1)
>>  #define ULLONG_MAX	(~0ULL)
>>  
>> +#define U16_MAX		((u16) ~0U)
>> +#define U32_MAX		((u32) ~0U)
>> +
>
>hm, I'd have thought that there's a risk of gcc warnings here, forcing
>0xffffffff into a u16, but apparently not.

No, since it is casted (= explicitly truncated).


	Jan
-- 
