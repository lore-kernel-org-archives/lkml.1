Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYHHVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYHHVxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbYHHVxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:53:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761150AbYHHVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:53:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Gy/r8bDyj5dUTc4XhiU9ua3GLAmHragNJ08szzigk9mOpXXv7iJl2TbcsDpQiH6sXc
         5LkRKmev6G+HHy6m628SGY0YE65/UjqctLbx7uKzW+nK2tMdFHzCHwSV4sVV8lTKe+RH
         31VAVO7wghE7JJOpVYvXMAk29fqdwfVaqsECM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
Date: Fri,  8 Aug 2008 14:52:06 -0700
Message-Id: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
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
   x86 32bit: have CONFIG_HAVE_DYN_ARRAY
   x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ

v5: apply alan cox patch with NR_IRQS for serial at first
   seperate irq_descX with irq_descX_free, so could use -1U as valid irq
   expand /proc/interrupts to process > nr_irqs
   hook irq_2_iommu to irq_desc
   more other arch irq_desc[] to irq_desc(), and kstat_cpu().irqs[] to kstat_irqs_cpu..

based on tip/master

to do:
   so dyn irq_desc is done, and ready to:
   make create_irq to get irq according to bus/dev/func/vector

Thanks

Yinghai Lu

