Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZFCO2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZFCO2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZFCO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:28:23 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:45412 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFCO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:28:22 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i1a3h6bh17ch)
X-FB-SS: 13,
X-WSS-ID: 0KKO2UY-01-PX8-01
Date: Wed, 3 Jun 2009 16:27:27 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 0/5 v3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090603142727.GI5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Jun 2009 14:28:13.0478 (UTC) FILETIME=[86FCEC60:01C9E457]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to previous patch set:
- remove MULTI_NODE_CPU config option
- provide defaults for cpu_node topology information
- add patch to fix AMD mcheck code

Current patch set contains 5 patches:
- patch 1 adapts common code to show cpu_node_id,
  cpu_node_siblings and cpu_node_siblings_list in
  /sys/devices/system/cpu/cpu*/topology
- patch 2 prepares arch/x86 to provide cpu_node information
- patch 3 sets up cpu_node information for AMD Magny-Cours CPU
- patch 4 fixes L3 cache information for Magny-Cours
- patch 5 fixes mcheck code for Magny-Cours

Patches are against tip/master.
Please apply.


Thanks,

Andreas

PS: See http://lkml.org/lkml/2009/5/29/263 for previous patch
    submission.


