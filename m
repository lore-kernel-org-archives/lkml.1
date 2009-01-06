Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZAFHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZAFHyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZAFHx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:53:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:12363 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZAFHx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d1UIY73a0YEdjquXrb5vWd724Q5HtCf1imjNI40p1Os0OKfR1a+vONj16J7AwGnFXc
         XHiYJKXen0fjnO5pO23H1YU3d8cK9vGVasefQJcUlwKBVo5r4rprQ82j0e9lMM+GFalQ
         u9flOQGICw1XZ94HhDbiOCG9n4l0t+G/YvVlI=
Message-ID: <3f9a31f40901052353p4147ae8dr49187088952a5c56@mail.gmail.com>
Date: Tue, 6 Jan 2009 13:23:55 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Cc: "Alain Knaff" <alain@knaff.lu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <49630715.1050204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
	 <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu>
	 <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu>
	 <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu>
	 <4962858F.20207@zytor.com>
	 <3f9a31f40901052318s7a5a421apa5c6ed8804aeb955@mail.gmail.com>
	 <49630715.1050204@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 12:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Jaswinder Singh Rajput wrote:
>>
>> On Tue, Jan 6, 2009 at 3:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> I'm thinking that with "preferred" we might just use the first one in the
>>> priority list "lzma, bzip2, gzip, uncompressed" depending on what is
>>> installed in the kernel.
>>
>> Only problem I faced with lzma is that, in some machines /usr/bin/lzma
>> is not installed by default which leads to error in kernel
>> compilations.
>>
>> Can we check in kernel config that lzma is installed on machine or not.
>
> For building the default initramfs, we'd do it in a script.  I don't think
> there is any way to check the system for configuration options, and I would
> argue that it *shouldn't* be, because it creates a
> silent failure condition.

Sorry, I was talking about kernel with CONFIG_KERNEL_LZMA=y

On some machines where /usr/bin/lzma was not installed I was getting
errors during kernel compilation. So I installed lzma package and then
kernel compiled for me on that machine.

--
JSR
