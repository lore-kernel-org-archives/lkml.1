Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXD0Hub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXD0Hub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbXD0Hub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:50:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153AbXD0HuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:50:20 -0400
Date: Fri, 27 Apr 2007 00:50:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v3: utimensat implementation
Message-Id: <20070427005010.d58ac519.akpm@linux-foundation.org>
In-Reply-To: <200704270308.l3R38axl031062@devserv.devel.redhat.com>
References: <200704270308.l3R38axl031062@devserv.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

urgh.

patching file arch/x86_64/ia32/ia32entry.S
Hunk #1 FAILED at 714.
1 out of 1 hunk FAILED -- saving rejects to file arch/x86_64/ia32/ia32entry.S.rej
patching file fs/compat.c
Hunk #1 FAILED at 79.
1 out of 1 hunk FAILED -- saving rejects to file fs/compat.c.rej
patching file fs/utimes.c
Hunk #2 FAILED at 77.
Hunk #3 FAILED at 101.
Hunk #4 FAILED at 134.
3 out of 4 hunks FAILED -- saving rejects to file fs/utimes.c.rej
patching file include/asm-i386/unistd.h
Hunk #1 FAILED at 325.
1 out of 1 hunk FAILED -- saving rejects to file include/asm-i386/unistd.h.rej
patching file include/asm-x86_64/unistd.h
Hunk #1 FAILED at 619.
1 out of 1 hunk FAILED -- saving rejects to file include/asm-x86_64/unistd.h.rej
patching file include/linux/stat.h
patching file include/linux/time.h
Hunk #1 FAILED at 109.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/time.h.rej

there's a little bit of intersection with lutimesat() there.

Can we revisit this in a couple of weeks please?
