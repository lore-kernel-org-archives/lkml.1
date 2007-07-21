Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXGUXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXGUXDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXGUXDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 19:03:08 -0400
Received: from barikada.upol.cz ([158.194.242.200]:56369 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXGUXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 19:03:07 -0400
To: Andi Kleen <ak@suse.de>
Cc: jh@suse.cz, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/58] x86_64: Always use builtin memcpy on gcc 4.3
In-Reply-To: <20070719095453.5434214E04@wotan.suse.de>
References: <200707191154.642492000@suse.de> <20070719095453.5434214E04@wotan.suse.de>
Date: Sun, 22 Jul 2007 01:16:42 +0200
Message-Id: <E1ICOBm-0003zf-Ms@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Andi Kleen <ak@suse.de>
* Date: Thu, 19 Jul 2007 11:54:53 +0200 (CEST)
>
> Jan asked to always use the builtin memcpy on gcc 4.3 mainline because
> it should generate better code than the old macro. Let's try it.

Unfortunately such info is hard to find. The discuss@x86-64 list is
empty. So, let me ask how this memcpy relates to recently submitted
for glibc one [0]?

[0] <http://permalink.gmane.org/gmane.comp.lib.glibc.alpha/12217>

Also you are enabling rep. string operations for 10h family. Yet manual
says, that while they were improved, there are still various other
preferred optimization cases

Thanks.

> Cc: jh@suse.cz
>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  include/asm-x86_64/string.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
____
