Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYCYViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYCYViU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYCYViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYCYViK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:10 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 0/20] dma_ops for i386
Date: Tue, 25 Mar 2008 18:36:19 -0300
Message-Id: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here there is a series of 20 patches that lays the foundations for
using dma_ops in i386 in the very same way x86_64, as well as many other
architectures already do.

The functions themselves for i386 are placed in a pci-base_32.c, but just
a few among them are actually implemented. Most were no-ops anyway.

Also, as I said, this is by no means a complete coverage of dma_ops.
there are still some call sites to be patches in pci-dma_32.c (although I don't
really plan to change them, but to integrate them in a single pci-dma.c).
I intend to have it done progressively.

The granularity is per-operation, meaning each patch moves one specific function
to the common header. This is compiled-tested in both i386 and x86_64 in 
~5 randconfigs each, and boot-tested in my hardware with my default configs

The motivation for that is the ongoing work for pci-passthrough in KVM.
So ingo, avi, what do you think it's the best way to handle these patches through?

Thanks


