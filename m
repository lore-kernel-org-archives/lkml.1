Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYGOPzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYGOPzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYGOPzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:55:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbYGOPzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:55:00 -0400
Subject: Re: [PATCH] x86: traps and do_traps under one hood
From: Jaswinder Singh <jaswinder@infradead.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1216129914.20462.1263591561@webmail.messagingengine.com>
References: <1216119158.21749.5.camel@jaswinder.satnam>
	 <1216129914.20462.1263591561@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf8
Date: Tue, 15 Jul 2008 21:24:09 +0530
Message-Id: <1216137250.2747.12.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ﻿Alexander,

On Tue, 2008-07-15 at 15:51 +0200, Alexander van Heukelum wrote:

> 
> I think moving the declarations to a header file is a good thing,
> but I don't think mach_traps.h is a suitable place. 

﻿I CC new patch to you : [PATCH] x86: Introducing asm-x86/traps.h

> The definitions
> of the functions are in entry_32.S and entry_64.S, so I would suggest
> making a new header include/asm-x86/entry.h. Some other ENTRY's
> (like system_call and some xen-specific ones) would then also fit
> in this header.
> 
> What do you think?

I did this for traps_32.c and traps_64.c because they are complaining
that traps are defined but not declared.

Thank you,

Jaswinder Singh.

