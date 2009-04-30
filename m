Return-Path: <linux-kernel-owner+w=401wt.eu-S933934AbZD3RuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbZD3RuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765153AbZD3RNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:13:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765179AbZD3RNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:13:44 -0400
Message-ID: <49F9DB70.2050906@zytor.com>
Date: Thu, 30 Apr 2009 10:10:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu>
In-Reply-To: <20090430154051.GA3346@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
>> index 80177ec..07a11b0 100644
>> --- a/arch/x86/Makefile_32.cpu
>> +++ b/arch/x86/Makefile_32.cpu
>> @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-f
>>  cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
>>  cflags-$(CONFIG_MVIAC7)		+= -march=i686
>>  cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
>> +cflags-$(CONFIG_MATOM)		+= -march=atom $(call tune,atom)
>>  

There should be a fallback option used here rather than requiring a new
gcc, e.g. something like:

$(call cc-option,-march=atom,-march=i686)

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

