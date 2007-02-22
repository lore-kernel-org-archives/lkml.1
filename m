Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbXBVWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbXBVWel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXBVWek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:34:40 -0500
Received: from terminus.zytor.com ([192.83.249.54]:42661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXBVWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:34:39 -0500
Message-ID: <45DE19AD.1010404@zytor.com>
Date: Thu, 22 Feb 2007 14:31:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: add -freg-struct-return to CFLAGS
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222083822.GB15068@elte.hu> <20070222183557.GC8603@stusta.de>
In-Reply-To: <20070222183557.GC8603@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Feb 22, 2007 at 09:38:22AM +0100, Ingo Molnar wrote:
>> ...
>> --- linux.orig/arch/i386/Makefile
>> +++ linux/arch/i386/Makefile
>> @@ -31,7 +31,7 @@ LDFLAGS_vmlinux := --emit-relocs
>>  endif
>>  CHECKFLAGS	+= -D__i386__
>>  
>> -CFLAGS += -pipe -msoft-float -mregparm=3
>> +CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
>>  
>>  # prevent gcc from keeping the stack 16 byte aligned
>>  CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
> 
> Why is this i386 specific?
> 

Because virtually all other architectures have it as their ABI default, 
anyway, and ABI selection should be per architecture.

	-hpa
