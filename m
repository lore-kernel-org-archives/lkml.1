Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbZFQXYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbZFQXYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762181AbZFQXYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:24:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46566 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbZFQXYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:24:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19001.31508.901222.288946@cargo.ozlabs.ibm.com>
Date: Thu, 18 Jun 2009 09:24:04 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/6] perf_counter: powerpc: Add processor back-end for MPC7450 family
In-Reply-To: <34BD6A89-A05E-40CC-A495-017BFB08B796@kernel.crashing.org>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	<19000.55631.802122.696927@cargo.ozlabs.ibm.com>
	<34BD6A89-A05E-40CC-A495-017BFB08B796@kernel.crashing.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> This should be something like:
> 
> obj64-$(CONFIG_PPC_PERF_CTRS)-$(PPC_BOOK3S_64)
> 
> > +obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
> 
> obj32-$(CONFIG_PPC_PERF_CTRS)-$(PPC_BOOK3S_32)
> 
> Or use new Kconfig types as I suggested on patch 1/6

Feel free to send a patch making those changes along with adding the
code to support the Freescale embedded PMU. :)

Paul.
