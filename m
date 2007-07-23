Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbXGWNkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbXGWNkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXGWNjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:39:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45697 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753828AbXGWNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:39:55 -0400
Date: Mon, 23 Jul 2007 14:46:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "jidong xiao" <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What does irq_canonicalize mean?
Message-ID: <20070723144647.1c232ff9@the-village.bc.nu>
In-Reply-To: <4104961b0707230612l7250489dk6064b9cd2170bfaf@mail.gmail.com>
References: <4104961b0707230612l7250489dk6064b9cd2170bfaf@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 21:12:22 +0800
"jidong xiao" <jidong.xiao@gmail.com> wrote:

> I found this function, inside include/asm-i386/irq.h or
> include/asm-x86_64/irq.h,

ISA bus interrupt 2 is remapped to 9 on 16bit PC ISA bus platforms. Thus
the user idea of "IRQ 2" is different to the hardware one
