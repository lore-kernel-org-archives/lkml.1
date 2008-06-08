Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYFHNqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYFHNqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYFHNp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:45:57 -0400
Received: from ns1.suse.de ([195.135.220.2]:40968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYFHNpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:45:55 -0400
Message-Id: <20080608134628.757299158@halley.suse.de>
User-Agent: quilt/0.46_cvs20080326-16
Date: Sun, 08 Jun 2008 15:46:28 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, vgoyal@redhat.com, anderson@redhat.com
Subject: [patch 0/3] [x86] Fix crashkernel reservation on NUMA machines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes the crashkernel reservation on NUMA machine. The
regression was discovered by Dave Anderson <anderson@redhat.com>.

The background is that on NUMA machines, reserve_bootmem_generic() is required
instead of reserve_bootmem(). To achieve that, it's necessary to make a few
API changes.

The patches are against latest linux-2.6 git. They should still go into 2.6.26
since it's only bug fixing. For 2.6.27, we should unify crashkernel reservation
for i386 and x86-64.

Tested on both i386 and x86-64. Compilation was tested with both kexec disabled
and enabled. The change is x86 only, so no need to test on other architectures.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Maintenance
