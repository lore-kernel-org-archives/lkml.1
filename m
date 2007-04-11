Return-Path: <linux-kernel-owner+w=401wt.eu-S1161152AbXDKBMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152AbXDKBMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161146AbXDKBMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:12:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161152AbXDKBM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:12:28 -0400
Date: Tue, 10 Apr 2007 18:12:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build error : 2.6.21-rc6-mm1 for ppc 405
Message-Id: <20070410181220.5257fce7.akpm@linux-foundation.org>
In-Reply-To: <20070411005042.GE15262@Krystal>
References: <20070411005042.GE15262@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:50:42 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Andrew,
> 
> I get the following build error when building 2.6.21-rc6-mm1 for ppc
> 405:
> 
> 
> /home/compudj/git/linux-2.6-lttng/arch/ppc/syslib/ppc4xx_sgdma.c: In function 'ppc4xx_alloc_dma_handle':
> /home/compudj/git/linux-2.6-lttng/arch/ppc/syslib/ppc4xx_sgdma.c:374: warning: implicit declaration of function 'dma_alloc_coherent'

gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch removes the pci.h
include, which presumably is what broke this.  Appropriate fix is to
include dma-mapping.h in ppc4xx_sgdma.c.  I queued a fix.


> /home/compudj/git/linux-2.6-lttng/arch/powerpc/sysdev/dcr.c:37: warning: 'struct device_node' declared inside parameter list

Srinivasa Ds <srinivasa@in.ibm.com> sent a fix for this today.


