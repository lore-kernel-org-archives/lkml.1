Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXA1Jlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXA1Jlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 04:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXA1Jlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 04:41:51 -0500
Received: from il.qumranet.com ([62.219.232.206]:58595 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbXA1Jlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 04:41:50 -0500
Message-ID: <45BC6FDC.5050208@qumranet.com>
Date: Sun, 28 Jan 2007 11:41:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
CC: linux-kernel@vger.kernel.org, caglar@pardus.org.tr,
       kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
References: <200701260140.47760.caglar@pardus.org.tr> <45BB15F1.6020600@qumranet.com> <200701271736.30271.pluto@agmk.net>
In-Reply-To: <200701271736.30271.pluto@agmk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paweł Sikora wrote:
> On Saturday 27 of January 2007 10:05:53 Avi Kivity wrote:
>
>   
>> "g" appears to be equivalent to "rmi", if "i" is impossible, gcc is free
>> to use "r" or "m", no?
>>     
>
> `r'
>      A register operand is allowed provided that it is in a general
>      register.
> `g'
>      Any register, memory or immediate integer operand is allowed,
>      except for registers that are not general registers.
>
> so, it looks like g == !r for registers ( not general vs. general regs ).
>   

I read it as g == !!r for registers ("except" and "not" constitute a 
double negative).


-- 
error compiling committee.c: too many arguments to function

