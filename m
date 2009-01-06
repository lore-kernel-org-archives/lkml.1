Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZAFHXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZAFHXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZAFHXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:23:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZAFHXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:23:34 -0500
Message-ID: <49630715.1050204@zytor.com>
Date: Mon, 05 Jan 2009 23:24:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>	 <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu>	 <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu>	 <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu>	 <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu>	 <4962858F.20207@zytor.com> <3f9a31f40901052318s7a5a421apa5c6ed8804aeb955@mail.gmail.com>
In-Reply-To: <3f9a31f40901052318s7a5a421apa5c6ed8804aeb955@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Tue, Jan 6, 2009 at 3:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I'm thinking that with "preferred" we might just use the first one in the
>> priority list "lzma, bzip2, gzip, uncompressed" depending on what is
>> installed in the kernel.
> 
> Only problem I faced with lzma is that, in some machines /usr/bin/lzma
> is not installed by default which leads to error in kernel
> compilations.
> 
> Can we check in kernel config that lzma is installed on machine or not.

For building the default initramfs, we'd do it in a script.  I don't 
think there is any way to check the system for configuration options, 
and I would argue that it *shouldn't* be, because it creates a
silent failure condition.

	-hpa
