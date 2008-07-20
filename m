Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYGTTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYGTTF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYGTTFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:05:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYGTTFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:05:14 -0400
Subject: Re: [PATCH] Introducing asm/syscalls.h
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       rth@twiddle.net, rmk@arm.linux.org.uk, hskinnemoen@atmel.com,
       cooloney@kernel.org, starvik@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, matthew@wil.cx,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, chris@zankel.net
In-Reply-To: <1216544940.12650.13.camel@jaswinder.satnam>
References: <1216544940.12650.13.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 12:05:11 -0700
Message-Id: <1216580711.2475.175.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 14:39 +0530, Jaswinder Singh wrote:
> 
> Declaring arch-dependent syscalls for all architectures
> Beneficial for kernel and userspace

Not really beneficial for userspace at all. Don't expose it.

I'm a little dubious about touching all architectures at once.

It might be nicer to do a first patch which adds an _empty_
<asm/syscalls.h> on each platform, and includes that from
<linux/syscalls.h>. And then follow up with one patch per architecture.

Have you compile-tested them all?

-- 
dwmw2

