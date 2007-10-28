Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXJ1SfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXJ1SfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXJ1SfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:35:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXJ1SfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:35:09 -0400
Message-ID: <4724D650.1050104@zytor.com>
Date: Sun, 28 Oct 2007 11:34:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: bwalle@suse.de, linux-kernel@vger.kernel.org
Subject: Re: build #286 failed for 2.6.24-rc1-gea45d15 in linux/arch/x86/kernel/setup_32.c
References: <200710281859.33374.toralf.foerster@gmx.de>
In-Reply-To: <200710281859.33374.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   CC      arch/x86/kernel/ioport_32.o
>   CC      arch/x86/kernel/ldt_32.o
>   CC      arch/x86/kernel/setup_32.o
> arch/x86/kernel/setup_32.c: In function 'setup_arch':
> arch/x86/kernel/setup_32.c:584: error: 'PARAM' undeclared (first use in this function)
> arch/x86/kernel/setup_32.c:584: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/setup_32.c:584: error: for each function it appears in.)
> make[1]: *** [arch/x86/kernel/setup_32.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> The build was made with an old .config from kernel 2.6.22-rc3
> (where the build also failed) :
> $> make mrproper && cp <oldconfig> .config && make oldconfig && make
> 

http://marc.info/?i=1193419828.3293.35.camel@localhost.localdomain
