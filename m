Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbXJKI4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbXJKI4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXJKI4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:56:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221AbXJKI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:56:30 -0400
Date: Thu, 11 Oct 2007 01:55:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
Message-Id: <20071011015553.cdf05128.akpm@linux-foundation.org>
In-Reply-To: <20071011011800.0c051792.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
	<20071011011800.0c051792.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 01:18:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Anyway, it breaks on ia64:

And on s390

In file included from arch/s390/kernel/binfmt_elf32.c:202:
arch/s390/kernel/../../../fs/binfmt_elf.c: In function 'load_elf_binary':
arch/s390/kernel/../../../fs/binfmt_elf.c:1088: error: implicit declaration of function 'arch_randomize_brk'

I'll drop the patch.

Really we should fix the elf mess before we try and change it any more.
