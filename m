Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYJ1Wmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYJ1Wmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYJ1WmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:42:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:48654 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbYJ1WmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:42:22 -0400
Date: Wed, 29 Oct 2008 07:41:30 +0900
To: James.Bottomley@HansenPartnership.com, jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, gcosta@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] x86: Fix CONFIG_PCI=n compile failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1225228943.3251.17.camel@localhost.localdomain>
References: <1225228943.3251.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081029074037S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 16:22:23 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> This:
> 
> commit fae9a0d8ca68a14da8d2351ad3e0bf42f3b29899
> Author: Glauber Costa <gcosta@redhat.com>
> Date:   Tue Apr 8 13:20:56 2008 -0300
> 
>     x86: merge iommu initialization parameters
> 
> Moved the forbid_dac parameter into pci-dma.c but forgot that it's a PCI
> only symbol thus causing a compile failure if CONFIG_PCI=N.  Fix by
> surrounding the set clause in iommu_setup with #ifdef CONFIG_PCI
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

http://marc.info/?l=linux-kernel&m=122480590627590&w=2


I guess that this patch is in the PCI tree.

Can you please send this quickly? I've seen bug reports due to this
too many times.
