Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbXKBEKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbXKBEKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 00:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXKBEKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 00:10:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXKBEKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 00:10:40 -0400
Message-ID: <472AA22C.20306@zytor.com>
Date: Thu, 01 Nov 2007 21:06:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: x86: <asm/sigcontext.h> not exported, but <asm/sigcontext32.h> is?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone happens to know how come, in the x86 tree (and previously in the 
x86-64 tree), <asm/sigcontext.h> is not exported to userspace (but uses 
userspace-compatible typenames), whereas <asm/sigcontext32.h> is?

This is particularly puzzling since at least my version of glibc 
contains an <asm/sigcontext.h> that looks just like the one in the 
kernel, minus a __user and an inclusion of <linux/compiler.h>.

	-hpa
