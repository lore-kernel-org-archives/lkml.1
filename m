Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZAFW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZAFW6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbZAFW6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:58:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbZAFW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:58:06 -0500
Message-ID: <4963E216.8020008@zytor.com>
Date: Tue, 06 Jan 2009 14:58:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bzip2/lzma] fix for built-in initramfs issue
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <49615136.9080900@knaff.lu> <4961580A.1020301@zytor.com> <4961A816.40302@knaff.lu> <4961A997.10108@zytor.com> <4961ADC5.6030108@knaff.lu> <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu> <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu> <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu> <4962858F.20207@zytor.com> <496285C8.7050503@knaff.lu> <496290E0.3020603@zytor.com> <4963D3C3.9090503@knaff.lu> <4963DFD5.9070204@zytor.com> <4963E020.7000304@knaff.lu>
In-Reply-To: <4963E020.7000304@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> H. Peter Anvin wrote:
>> Alain Knaff wrote:
>>> It also restores the select ZLIB_INFLATE in drivers/block/Kconfig
>>> which somehow came missing. This is needed to activate compilation of
>>> the stuff in zlib_deflate.
>> It's not missing.  It is (or at least should be) included via the
>> dependency chain DECOMPRESS_GZIP -> ZLIB_INFLATE.
>>
>>     -hpa
> 
> Well, that didn't work when I tried it here...
> 

OK, let's fix the dependency chain then.  I'll mess with it.

	-hpa
