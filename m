Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZHGM4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZHGM4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbZHGM4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:56:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:20620 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbZHGM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:56:23 -0400
X-SpamScore: 14
X-BigFish: VPS14(zz4015Lzz1202hzz3198u327alz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO0BXO-01-29M-02
X-M-MSG: 
Date: Fri, 7 Aug 2009 14:56:09 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 0/8 v5] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090807125609.GH7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Aug 2009 12:56:10.0355 (UTC) FILETIME=[6FCCFC30:01CA175E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to previous patch set:
- added patch to swap semantic of cpu_node_siblings and core_siblings
- new patch to convert alloc/clear of cpumask to zalloc
- added patch to update cputopology documentation

Current patch set contains 8 patches:
- patch 1 adapts common code to show cpu_node_id,
  cpu_node_siblings and cpu_node_siblings_list in
  /sys/devices/system/cpu/cpu*/topology
- patch 2 prepares arch/x86 to provide cpu_node information
- patch 3 sets up cpu_node information for AMD Magny-Cours CPU
- patch 4 swap semantic of cpu_node_siblings and core_siblings
- patch 5 fixes L3 cache information for Magny-Cours
- patch 6 fixes mcheck code for Magny-Cours
- patch 7 alloc/clear to zalloc conversion
- patch 8 documentation update

Note that scheduler adaptions are still under construction/test.
(I'll have to adapt domain hierarchy to the semantic change.)


Patches are against tip/master.
Please apply.

Thanks,

Andreas

PS: See http://marc.info/?l=linux-kernel&m=124948708626238 for
    previous patch submission.


