Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZAFI1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZAFI1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZAFI12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:27:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34579 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZAFI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:27:27 -0500
Message-ID: <496315E3.8050906@zytor.com>
Date: Tue, 06 Jan 2009 00:27:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>	 <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu>	 <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu>	 <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu>	 <4962858F.20207@zytor.com>	 <3f9a31f40901052318s7a5a421apa5c6ed8804aeb955@mail.gmail.com>	 <49630715.1050204@zytor.com> <3f9a31f40901052353p4147ae8dr49187088952a5c56@mail.gmail.com>
In-Reply-To: <3f9a31f40901052353p4147ae8dr49187088952a5c56@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>>>
>>> Can we check in kernel config that lzma is installed on machine or not.
>> For building the default initramfs, we'd do it in a script.  I don't think
>> there is any way to check the system for configuration options, and I would
>> argue that it *shouldn't* be, because it creates a
>> silent failure condition.
> 
> Sorry, I was talking about kernel with CONFIG_KERNEL_LZMA=y
> 
> On some machines where /usr/bin/lzma was not installed I was getting
> errors during kernel compilation. So I installed lzma package and then
> kernel compiled for me on that machine.
> 

Right, well, that's to be expected.  (There was a bug earlier on which
would cause it to "complete" incorrectly... not good for obvious reasons.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

