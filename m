Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbXGOQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbXGOQGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762593AbXGOQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:04:50 -0400
Received: from www.osadl.org ([213.239.205.134]:42524 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762581AbXGOQEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:49 -0400
Message-Id: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>
Subject: [patch-mm 00/33] x86_64 clock events conversion - V5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a replacement patch series for the patches in -mm.

Functional changes since last version:

- hpet legacy problem solved
- apic calibration reverted to original x8664 code

Otherwise the code is the same as before, but the patches got split up
further. Linus, thanks for the hints.

The series is fully bisectable and hopefully easier to review now.

	tglx

-- 

