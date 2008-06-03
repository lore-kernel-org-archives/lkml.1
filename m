Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYFCKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYFCKbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYFCKbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:31:09 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:51071 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYFCKbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:31:08 -0400
Date: Tue, 3 Jun 2008 12:31:12 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
Message-ID: <20080603123112.0d58e193@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2008 10:30:43.0574 (UTC) FILETIME=[E09B6160:01C8C564]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>  include/asm-alpha/thread_info.h     |    4 +---
>  include/asm-arm/thread_info.h       |   13 -------------
>  include/asm-blackfin/thread_info.h  |    5 +----
>  include/asm-cris/thread_info.h      |    2 ++
>  include/asm-frv/thread_info.h       |    2 ++
>  include/asm-h8300/thread_info.h     |    5 +----
>  include/asm-ia64/thread_info.h      |    2 ++
>  include/asm-m32r/thread_info.h      |    2 ++
>  include/asm-m68k/thread_info.h      |    8 +-------
>  include/asm-m68knommu/thread_info.h |    4 ----
>  include/asm-mips/thread_info.h      |    2 ++
>  include/asm-mn10300/thread_info.h   |    2 ++
>  include/asm-parisc/thread_info.h    |   10 +++-------
>  include/asm-powerpc/thread_info.h   |   14 +++-----------
>  include/asm-s390/thread_info.h      |    5 +----
>  include/asm-sh/thread_info.h        |    2 ++
>  include/asm-sparc/thread_info.h     |    2 ++
>  include/asm-sparc64/thread_info.h   |   23 ++---------------------
>  include/asm-um/thread_info.h        |   16 +---------------
>  include/asm-x86/thread_info.h       |    2 ++
>  include/asm-xtensa/thread_info.h    |    5 +----
>  kernel/fork.c                       |   17 +++++++++++++++++
>  22 files changed, 50 insertions(+), 97 deletions(-)

Can you do the same with avr32 as well?

Haavard
