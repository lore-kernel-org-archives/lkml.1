Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYHUACv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYHUACv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYHUACm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:02:42 -0400
Received: from gw.goop.org ([64.81.55.164]:49148 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYHUACl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:02:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 4] Xen spinlock updates and performance measurements
Message-Id: <patchbomb.1219276937@localhost>
Date: Wed, 20 Aug 2008 17:02:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series has some updates to Xen's spinlock implementation,
including adding a set of performance measurements in debugfs.

The series consists of:
 - correctly deal with a spinlock in an interrupt handler interrupting
   another spinlock spinning on a lock. [2.6.27 bugfix]
 - Add Xen debugfs support, including performance metrics for
   spinlocks, multicalls and mmu operations.
 - Allow interrupts to be enabled while spinning (blocking) for a lock
 - Measure time spinlocks spend blocked

Thanks,
	J

