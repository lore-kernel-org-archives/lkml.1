Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbXDWXQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbXDWXQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXDWXH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:07:26 -0400
Received: from 61.sub-75-208-107.myvzw.com ([75.208.107.61]:38852 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932478AbXDWXHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:07:19 -0400
Message-Id: <20070423215638.563901986@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 14:56:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/25] xen: Xen implementation for paravirt_ops
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This series of patches implements the Xen paravirt-ops interface.
It applies to 2.6.21-rc7 + your patches + the last batch of pv_ops
patches I posted.

This patch generally restricts itself to Xen-specific parts of the tree,
though it does make a few small changes elsewhere.

These patches include:
 - some helper routines for allocating address space and walking pagetables
 - Xen interface header files
 - Core Xen implementation
 - Efficient late-pinning/early-unpinning pagetable handling
 - Virtualized time, including stolen time
 - SMP support
 - Preemption support
 - Batched pagetable updates
 - Xen console, based on hvc console
 - Xenbus
 - Netfront, the paravirtualized network device
 - Blockfront, the paravirtualized block device

Thanks,
	J
-- 

