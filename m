Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbYIIRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbYIIRGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYIIRGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:06:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbYIIRGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:06:01 -0400
Message-ID: <48C6ABF8.7050205@zytor.com>
Date: Tue, 09 Sep 2008 10:01:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>	<48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org>	<48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu>	<alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>	<m3vdx6xm68.fsf@maximus.localdomain> <87d4jdty5b.fsf@basil.nowhere.org>
In-Reply-To: <87d4jdty5b.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Krzysztof Halasa <khc@pm.waw.pl> writes:
> 
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>
>>>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
>>>    granted.
>> VIA C3 (Samuel 2/Ezra, 600 - 1000 MHz?, common on VIA EPIA-*: home
>> theatres etc) can't CMOV.
> 
> AFAIK they fixed that in newer BIOS with a microcode update. It's 
> slow, but it works.
> 

Yes, but if it's slower than jmp+mov than you actively want to avoid it.

	-hpa
