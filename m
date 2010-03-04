Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0CDP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:29:42 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43067 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720Ab0CDP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:29:40 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       benh@kernel.crashing.org, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267712512.31654.176.camel@mulgrave.site>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 15:29:38 +0000
Message-ID: <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 15:29:39.0068 (UTC) FILETIME=[80F4D3C0:01CABBAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 14:21 +0000, James Bottomley wrote:
> The thing which was discovered in this thread is basically that ARM is
> handling deferred flushing (for D/I coherency) in a slightly different
> way from everyone else ... 

Doing a grep for PG_dcache_dirty defined in terms of PG_arch_1 reveals
that MIPS, Parisc, Score, SH and SPARC do similar things to ARM. PowerPC
and IA-64 use PG_arch_1 as a clean rather than dirty bit.

-- 
Catalin

