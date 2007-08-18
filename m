Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXHRTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXHRTyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbXHRTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:54:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39605 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbXHRTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:54:08 -0400
Date: Sat, 18 Aug 2007 21:54:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Xu Yang <risingsunxy@googlemail.com>
cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: how to add debug information into the vmlinux
In-Reply-To: <ab40e9c0708181249l7389c300sd68964e22bf262a9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708182152350.5186@fbirervta.pbzchgretzou.qr>
References: <ab40e9c0708171349n73e35f58p5f5c092b54ddeb45@mail.gmail.com> 
 <9a8748490708171430u2be506canf640d5c8c97149c6@mail.gmail.com>
 <ab40e9c0708181249l7389c300sd68964e22bf262a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18 2007 21:49, Xu Yang wrote:
>
>I tried as what you told me. and the vmlinux does contain debug
>information. but the start address of this vmlinux is 0xc0008000. when
>I tried to run this vmlinux, the program always exit at 0x80a0. I
>checked out that here is the place mmu is turned on.
>so I used objcopy --change-addresses 0x40000000 to change the start
>address of the vmlinux, and the program goes further.but the debug
>information disappeared.

Are you using an UML image... or were you really trying to gdb a real vmlinux?



	Jan
-- 
