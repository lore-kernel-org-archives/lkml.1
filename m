Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZAVNdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZAVNdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZAVNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:33:08 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:63985 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZAVNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V9jOkWYFWEg8DG17kdWJQ2uYTSMiql5CtJw/HHE2hroS7iDIQf6c0G8nVKFWGnkw8+
         8y5emn5i7XBDjkLIZqrz1jOh/Ia0qq4L/i0LBlvA4YR6ZFpJg68/DAc7pNhOPdO11D15
         MI+iLcmE4FI7QdLILnm35aQsoYnBnyP5AHEXU=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 08:33:04 -0500
Message-ID: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
Subject: [PATCH 0/5] x86: Merge hardirq.h
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series merges the 32-bit and 64-bit hardirq.h headers and
does several associated cleanups.  Based on tip/core/percpu.

 arch/x86/include/asm/hardirq.h    |   49 ++++++++++++++++++++++++++++++++++---
 arch/x86/include/asm/hardirq_32.h |   33 -------------------------
 arch/x86/include/asm/hardirq_64.h |   39 -----------------------------
 arch/x86/kernel/efi_64.c          |    1 +
 arch/x86/kernel/irq_64.c          |    1 +
 arch/x86/kernel/process_32.c      |    1 -
 6 files changed, 47 insertions(+), 77 deletions(-)

--
Brian Gerst
