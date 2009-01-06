Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZAFHVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZAFHVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZAFHVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:21:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAFHVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:21:41 -0500
Message-ID: <496306A2.9080600@zytor.com>
Date: Mon, 05 Jan 2009 23:22:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <49615136.9080900@knaff.lu> <4961580A.1020301@zytor.com> <4961A816.40302@knaff.lu> <4961A997.10108@zytor.com> <4961ADC5.6030108@knaff.lu> <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu> <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu> <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu> <4962858F.20207@zytor.com> <496285C8.7050503@knaff.lu> <496290E0.3020603@zytor.com> <4963039D.7000804@knaff.lu>
In-Reply-To: <4963039D.7000804@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> H. Peter Anvin wrote:
>> Go ahead and do an incremental patch at this point.
>>
>>     -hpa
> 
> Thanks, that'll make things easier. Unfortunately, I can no longer check
> out the code. No error messages, but the files just aren't there:
> 
> 
>> git pull
> Already up-to-date.
>> git checkout -b x86/setup-lzma tip/x86/setup-lzma
> git checkout: branch x86/setup-lzma already exists

I think the "git checkout" failed here because you were trying to create 
a local branch (-b) failed.  Just "git checkout x86/setup-lzma" followed 
by "git pull" *should* work...

>> ls lib/decompress_inflate.c
> ls: cannot access lib/decompress_inflate.c: No such file or directory
> 

If that doesn't work, you may want to ask the people in #git on Freenode.

	-hpa

