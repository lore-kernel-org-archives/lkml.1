Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXCTVFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXCTVFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXCTVFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:05:16 -0400
Received: from smtp.ono.com ([62.42.230.12]:62310 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750951AbXCTVFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:05:15 -0400
Date: Tue, 20 Mar 2007 22:04:57 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070320220457.276429b0@werewolf-wl>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1cvs22 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 

After applying hot-fixes, I get this:

MODPOST vmlinux
WARNING: init/built-in.o - Section mismatch: reference to .init.text: from .text between 'rest_init' (at offset 0xfa) and 'try_name'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:cpu_set_gdt from .text between 'initialize_secondary' (at offset 0xbce3) and 'mp_find_ioapic'
WARNING: mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x1b384) and 's_start'

If you need anything, just ask (.config or the like)

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
