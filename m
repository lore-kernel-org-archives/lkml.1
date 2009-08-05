Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbZHEPo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbZHEPo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZHEPo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:44:26 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42322 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbZHEPoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:44:25 -0400
X-SpamScore: 14
X-BigFish: VPS14(zz4015Lzz1202hzz3198u327alz32i203h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNWUDR-01-0IJ-02
X-M-MSG: 
Date: Wed, 5 Aug 2009 17:44:02 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090805154402.GA6520@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Aug 2009 15:44:03.0302 (UTC) FILETIME=[8EEB3860:01CA15E3]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to previous patch set:
- fixed allnoconfig compile error and link error if CONFIG_PCI=n
- fixed hotplug issue: cpumask of siblings sharing same L3 were not
  properly updated
- properly allocate cpu_node_map

Current patch set contains 5 patches:
- patch 1 adapts common code to show cpu_node_id,
  cpu_node_siblings and cpu_node_siblings_list in
  /sys/devices/system/cpu/cpu*/topology
- patch 2 prepares arch/x86 to provide cpu_node information
- patch 3 sets up cpu_node information for AMD Magny-Cours CPU
- patch 4 fixes L3 cache information for Magny-Cours
- patch 5 fixes mcheck code for Magny-Cours

Note that scheduler adaptions are still under construction/test. Hope
to send first version as RFC by end of this week.

Patches are against tip/master.
Please apply.

Thanks,

Andreas

PS: See http://marc.info/?l=linux-kernel&m=124403937804836 for
    previous patch submission.

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


