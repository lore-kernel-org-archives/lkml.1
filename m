Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbYHFIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbYHFIoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYHFIoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:44:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYHFIn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HlFxKOyeyxBjknqzwY8e++9MDMhLGTRdAcn+71yMP4NFT9M5xmWfAwHVmvvova7pQH
         xEeJqaHha0L0CMnVRdA/9Hnr/t6TqHz5IkB9EtTcqfJbNS/caf3+XCzxLvvDpd27qRSG
         ucvMVMV5shaV2FYjE60iY0x+KssQ3E6xasZ5s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/33] dyn_array and nr_irqs support v4
Date: Wed,  6 Aug 2008 01:42:42 -0700
Message-Id: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check dyn_array support for x86
v3: split changing to nr_irqs to small patches
    fix checkpatch error
    reorder the patch sequence to make dyn_array support go at first
        so could use that with arrays other than NR_IRQS
v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
    so could use 32 init, and init more if needed.

now: x86 32bit: have CONFIG_HAVE_DYN_ARRAY
     x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ

left:
a. hook irq_2_iommu to irq_desc ?
b. expand /proc/interrupts to process > nr_irqs
c. expand to use irq > nr_irqs for msi

notes: may break some arch compling...

Thanks

Yinghai Lu
