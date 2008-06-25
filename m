Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYFYT4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYFYT4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYFYT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:56:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:38925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYFYT43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:56:29 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, Bernhard Walle <bwalle@suse.de>
Subject: x86: Add /sys/firmware/memmap
Date: Wed, 25 Jun 2008 21:57:04 +0200
Message-Id: <1214423826-12628-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a new interface /sys/firmware/memmap
to export the BIOS (Firmware) provided memory map via sysfs
for usage with kexec.

While the first patch adds the generic interface, the second
patch implements that interface for E820 on x86. EFI is on the TODO
list, and other architectures can be added later.

This patch is RFC. It has been tested on x86-64 and i386 and
replaces my previous attemt that adds such an interface via
procfs.


Signed-off-by: Bernhard Walle <bwalle@suse.de>


