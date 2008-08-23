Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYHWNBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYHWNBO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYHWNA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:00:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYHWNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qP14/20Ixc0QL1t0bnjfYf8wOKBjYrY4mtBPpRfHYZ4c9uxQanU3L/zzNJpx9AxMFP
         rNqyfA0DXzE8ySV8L/pYRbT1s6I/nO218/D8n0NEutJwaFNZPtl2thdzZ+EbLeJec8Pt
         PT67qM9us4h0nZTsxp6tEBDX2hGZ/Ltna7+QE=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] tip/x86/apic - merging snippet
Date: Sat, 23 Aug 2008 17:01:17 +0400
Message-Id: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi, it seems I'm braking apic merging (due to lack of time)
so here is small series of merging patches. The pactes actually
becoming more and more... well... harmfull I would say so please
check them twise - especially:

5/8 -	I've moved hard_smp_processor_id to apic from the header
	since for x86 we're linked to apic code anyway
6/8 -	setup_local_APIC now uses preempt_disable/enable on 32bit
	mode

Any comments are quite welcome.

The patches are over the -tip/x86/apic

commit 11494547b1754c4f3bd7f707ab869e2adf54d52f
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Thu Aug 21 01:01:19 2008 -0700

    x86: fix apic version warning
    
    after following patch,

I noticed Yinghai posted variables ordering patch - if
the series would conflict - just letme know.

		- Cyrill -
