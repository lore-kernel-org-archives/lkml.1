Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbXEUQgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbXEUQgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbXEUQf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:35:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXEUQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:35:55 -0400
Message-ID: <4651CA63.9030903@zytor.com>
Date: Mon, 21 May 2007 09:35:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: young dave <hidave.darkstar@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>	 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>	 <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>	 <464DDA40.6010101@zytor.com>	 <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>	 <465124EA.1020801@zytor.com>	 <a8e1da0705202200u5976d14do7ec1469941bb2967@mail.gmail.com>	 <46512821.9010905@zytor.com>	 <a8e1da0705202239r31d03a5dyc2f0ce6a795e0124@mail.gmail.com>	 <465138CC.3060605@zytor.com> <a8e1da0705210141m4d9f0ccevde3060fefcc55537@mail.gmail.com>
In-Reply-To: <a8e1da0705210141m4d9f0ccevde3060fefcc55537@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

young dave wrote:
> Hi,
> 
> kernel booting and stopped in edd.c:read_sector.
> 
> I add debug messages around the two inline assemblly sentence, recompile
> kernel,
> now strange thing happend, the kernel booting directly, but the printf
> messages can't be seen because it's too rapid.
> 
> can we use printk in boot code?

Well, it's spelt "printf", but same thing.  (Since it doesn't take a
logging priority, it seems better to name it printf.)

This implies a miscompile somewhere, *or* that your bios stomps on
registers that gcc expect preserved, and adding printf's disturbs the
register allocation sufficiently.

Could you send me the arch/i386/boot/setup.elf file from the original,
failed, build?

Thanks.

	-hpa
