Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZHCDV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZHCDV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 23:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZHCDV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 23:21:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60136
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbZHCDV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 23:21:27 -0400
Date: Sun, 02 Aug 2009 20:21:35 -0700 (PDT)
Message-Id: <20090802.202135.63875488.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090718110620.GC27287@elte.hu>
References: <20090714092354.GL19087@amd.com>
	<20090714.131224.205307048.davem@davemloft.net>
	<20090718110620.GC27287@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 18 Jul 2009 13:06:20 +0200

> I'm wondering why sparc32 frees from the middle of the kernel image. 
> The way architectures generally do it is to put freeable pages into 
> a separate section. That way it does not get mingled with the kernel 
> core image area (which stays nicely continuous).

It's conditionally free'able, we actually use the pages
if the system is SMP and has more than cpu 0 installed.
