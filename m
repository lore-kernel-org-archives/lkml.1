Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbXJGRDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbXJGRDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 13:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXJGRDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 13:03:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44531 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXJGRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 13:03:08 -0400
Date: Sun, 7 Oct 2007 19:03:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
In-Reply-To: <20071007165953.GB32139@elte.hu>
Message-ID: <Pine.LNX.4.64.0710071902410.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
 <20071007163824.GA30063@elte.hu> <20071007164452.GA30429@elte.hu>
 <Pine.LNX.4.64.0710071849240.16301@fbirervta.pbzchgretzou.qr>
 <20071007165953.GB32139@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 18:59, Ingo Molnar wrote:
>> >  vmlinux:
>> >     text    data     bss     dec     hex filename
>> >  7732358 1157269  401408 9291035  8dc51b vmlinux.before
>> >  7732374 1157269  401408 9291051  8dc52b vmlinux.after
>> >
>> >16 bytes, or 0.0002% of the total text size. So there's in essence no 
>> >text overhead to talk about. So the text overhead argument is a red 
>> >herring.
>> 
>> 16 bytes, huh? Can't be. That would be like, perhaps 5, x86 instructions.
>
>yes, it's that low, and it's with the feature disabled.

Ah, with CONFIG_CKO=n, right. But where does that 16 byte increase
come from, when vt.o itself remains constant in size?
