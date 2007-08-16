Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbXHPUQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbXHPUQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXHPUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:16:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40289 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752646AbXHPUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:16:04 -0400
Date: Thu, 16 Aug 2007 21:23:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Authenticated <NWQ3MzhlY2QwZDAzODVhN@steudten.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.20:  INFO: possible circular locking dependency
 detected
Message-ID: <20070816212348.0d260d06@the-village.bc.nu>
In-Reply-To: <46C48E73.8090309@steudten.com>
References: <46C48E73.8090309@steudten.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007 19:50:43 +0200
Authenticated <NWQ3MzhlY2QwZDAzODVhN@steudten.com> wrote:

> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.20-1.2948.self #1
> -------------------------------------------------------
> squid/4058 is trying to acquire lock:
>  (tty_mutex){--..}, at: [<c019fb54>] print_warning+0x8b/0x12e
> 
> but task is already holding lock:
>  (&s->s_dquot.dqptr_sem){----}, at: [<c01a0802>] dquot_alloc_inode+0x34/0x10a
> 
> which lock already depends on the new lock.

Yep - known 2.6.20 problem. Its very very unlikely to ever cause a real
problem however.
