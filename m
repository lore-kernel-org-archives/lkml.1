Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbYDYTn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbYDYTn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYDYTnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:43:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38158 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYDYTnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:43:51 -0400
Date: Fri, 25 Apr 2008 21:43:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
In-Reply-To: <48123325.30003@zytor.com>
Message-ID: <alpine.LNX.1.10.0804252143170.20150@fbirervta.pbzchgretzou.qr>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org>
 <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com> <20080425192858.GM14990@parisc-linux.org> <48123325.30003@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-04-25 21:38, H. Peter Anvin wrote:
>> Understood, and agreed.  It just seemed like an opportune time to
>> mention the problem of printing a u64.
>> 
>
> I have to admit to liking the Windows extension %I64u for this kind of stuff.
> Unfortunately gcc/glibc decided to use I for internationalized digits instead
> :(

In the kernel's *printk, we are free to do what we want :)

%_64u perhaps?
