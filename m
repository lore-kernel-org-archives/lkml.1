Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0BQOfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:35:21 -0500
Received: from www.tglx.de ([62.245.132.106]:46563 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0BQOfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:35:20 -0500
Message-Id: <20100217143401.673569070@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 14:35:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 0/2] pci: raw_spinlock annotations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preempt-RT converts spinlocks to sleeping spinlocks, but some
spinlocks need to be kept as real spinlocks. In 2.6.33 we merged the
spinlock namespace cleanup which allows us to annotate those
locks. The lock type is changed to raw_spinlock which is the same as a
common spinlock in !RT kernels.

The following series is a collection of lock annotations from the
preempt-rt tree. Please merge into 2.6.34.

Thanks,

	tglx



