Return-Path: <linux-kernel-owner+w=401wt.eu-S935152AbXGZXIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbXGZXIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbXGZXH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:07:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbXGZXH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:07:57 -0400
Date: Thu, 26 Jul 2007 16:07:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: 07/26 GIT - Build breakage
In-Reply-To: <46A924A0.9010501@gmail.com>
Message-ID: <alpine.LFD.0.999.0707261605560.3442@woody.linux-foundation.org>
References: <46A924A0.9010501@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Parag Warudkar wrote:
>
> arch/i386/kernel/paravirt.o: In function `init_IRQ':
> (.text+0xb20): multiple definition of `init_IRQ'
> arch/i386/kernel/i8259.o:(.init.text+0x30): first defined here
> ld: Warning: size of symbol `init_IRQ' changed from 66 in
> arch/i386/kernel/i8259.o to 14 in arch/i386/kernel/paravirt.o
> make[1]: *** [arch/i386/kernel/built-in.o] Error 1
> make: *** [arch/i386/kernel] Error 2

Ok, it seems that some versions of gcc/binutils have problems with the 
games that paravirt introduced with the "weak" thing. 

I'm not entirely surprised. That stuff was trying to be too clever by 
half.

Rusty?

		Linus
