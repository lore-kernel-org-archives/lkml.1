Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbZDAIyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbZDAIyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbZDAIyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:54:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33858
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760642AbZDAIyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:54:02 -0400
Date: Wed, 01 Apr 2009 01:53:50 -0700 (PDT)
Message-Id: <20090401.015350.161544996.davem@davemloft.net>
To: schwidefsky@de.ibm.com
Cc: tj@kernel.org, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       lethal@linux-sh.org, rmk@arm.linux.org.uk, starvik@axis.com,
       ralf@linux-mips.org, cooloney@kernel.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090401104737.22c8c66c@skybase>
References: <20090401103257.12c2517e@skybase>
	<20090401.013702.66171229.davem@davemloft.net>
	<20090401104737.22c8c66c@skybase>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Wed, 1 Apr 2009 10:47:37 +0200

> We have thought about that solution as well but it not really a good
> one. For a machine with more than 4GB of memory we would either loose
> the memory that overlaps with the module area or we'd have to play
> nasty remapping tricks. On s390 the kernel image is linked to address 0
> (PAGE_OFFSET==0) and we have a simple 1:1 mapping for all real memory.

Flexibility can often cost you a few TLB entries, but that's
life :-)
