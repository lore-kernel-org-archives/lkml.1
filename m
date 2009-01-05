Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZAEW7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZAEW7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZAEW7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:59:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAEW7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:59:35 -0500
Message-ID: <496290E0.3020603@zytor.com>
Date: Mon, 05 Jan 2009 14:59:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <49615136.9080900@knaff.lu> <4961580A.1020301@zytor.com> <4961A816.40302@knaff.lu> <4961A997.10108@zytor.com> <4961ADC5.6030108@knaff.lu> <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu> <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu> <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu> <4962858F.20207@zytor.com> <496285C8.7050503@knaff.lu>
In-Reply-To: <496285C8.7050503@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> H. Peter Anvin wrote:
>> I'm thinking that with "preferred" we might just use the first one in
>> the priority list "lzma, bzip2, gzip, uncompressed" depending on what is
>> installed in the kernel.
>>
>> Using the kernel method may definitely not work, especially on
>> architectures which don't do this style of kernel compression.
>>
>>     -hpa
> 
> Ok. For the new change, may I do a diff against the current
> x86/lzma-setup , or should I do the whole 5-part dance again?
> 

Go ahead and do an incremental patch at this point.

	-hpa

