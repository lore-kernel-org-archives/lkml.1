Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbXGCJig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbXGCJig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbXGCJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:38:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902AbXGCJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:38:28 -0400
Date: Tue, 3 Jul 2007 02:38:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: How to handle patches that cross maintainers?
Message-Id: <20070703023805.f174b5b8.akpm@linux-foundation.org>
In-Reply-To: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
References: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 04:01:20 -0500 Kumar Gala <galak@kernel.crashing.org> wrote:

> Andrew,
> 
> I was hoping to get your input on how to handle patches that cross  
> maintainers.  I've got a patch that is pretty PPC specific, but  
> happens to touch some drivers as well.
> 
> Here's the diffstat to get a rough idea:
> 
> arch/powerpc/kernel/io.c                |   12 ++++++------
> arch/powerpc/mm/hash_native_64.c        |    2 +-
> arch/powerpc/mm/stab.c                  |    4 ++--
> drivers/ide/pci/scc_pata.c              |    4 ++--
> drivers/media/dvb/bt8xx/bt878.h         |    5 ++---
> drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
> include/asm-powerpc/system.h            |    2 +-
> 7 files changed, 15 insertions(+), 16 deletions(-)
> 
> Now, I've had this issue before w/o any good sense on how to handle it.
> 
> Suggestions?
> 

Well, assuming that all the changes are interdependent and cannot be split
up: send it to the relevant maintainers, gather the acks and merge it up
yourself.

