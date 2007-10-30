Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXJ3IvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXJ3IvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXJ3IvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:51:00 -0400
Received: from koto.vergenet.net ([210.128.90.7]:33033 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbXJ3Iu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:50:59 -0400
Date: Tue, 30 Oct 2007 17:50:56 +0900
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: luming.yu@gmail.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] fix typo in per_cpu_offset
Message-ID: <20071030085054.GE10635@verge.net.au>
References: <3877989d0710230015x1640388aod98cae2fa3fc82c2@mail.gmail.com> <20071030071513.GE5361@verge.net.au> <20071030.003622.265888160.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030.003622.265888160.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 12:36:22AM -0700, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Tue, 30 Oct 2007 16:15:13 +0900
> 
> > Though curiuously with my config nothing uses per_cpu_offset()
> > (I added a bogus call to produce an error.) Is it actually
> > used on ia64?
> 
> It is unused, and in that regard should probably be deleted.
> 
> include/asm-generic/percpu.h defines a seemingly similarly
> unused per_cpu_offset() macro define as well

It looks like they were both added by "[PATCH] lockdep: add per_cpu_offset()"
(a875a69f8b00a38b4f40d9632a4fc71a159f0e0d)

Perhaps they were used at that time?

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

