Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbYDRIBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbYDRIBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYDRIAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:00:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbYDRIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:00:54 -0400
Date: Fri, 18 Apr 2008 01:00:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080418010008.2fb29e5c.akpm@linux-foundation.org>
In-Reply-To: <20080418074736.GA27579@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417232747.4c04f413.akpm@linux-foundation.org>
	<20080417.233856.238029159.davem@davemloft.net>
	<20080418074736.GA27579@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 09:47:42 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> so i'm not sure where those "over a megabyte of warnings" come from.

allmodconfig.

In file included from include/linux/mm.h:39,
                 from include/linux/scatterlist.h:6,
                 from include/asm/dma-mapping.h:4,
                 from include/linux/dma-mapping.h:52,
                 from include/asm/pci.h:6,
                 from include/linux/pci.h:945,
                 from drivers/ata/ata_generic.c:21:
include/asm/pgtable.h: In function `set_pte_at':
include/asm/pgtable.h:670: warning: `init_mm' is deprecated (declared at include/linux/sched.h:1616)
