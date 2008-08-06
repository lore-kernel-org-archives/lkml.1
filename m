Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbYHFIkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbYHFIkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbYHFIkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:40:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:10879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbYHFIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cCzGqWoCgPoI0vVwFMt+j0r09BRnv/uQQK6167RnDaPknETXMNKbIXsXAxab+E75zd
         nBb6RqUpyXepHWxXpCSNByCC6LNjLwHUQaEH2UkMiBJ1FM4MjkFcovYKHDOU+ZMKwOB2
         L72CcP0G/JEXpCAC0fRsx0dtK2HKYk5+bxIfM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/33] dyn_array and nr_irqs support v4
Date: Wed,  6 Aug 2008 01:38:24 -0700
Message-Id: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <No>
References: <No>
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
