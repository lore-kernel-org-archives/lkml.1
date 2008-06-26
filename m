Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYFZUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYFZUSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbYFZUS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:18:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136AbYFZUSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:18:25 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       yhlu.kernel@gmail.com, gregkh@suse.de, Bernhard Walle <bwalle@suse.de>
Subject: x86: Add /sys/firmware/memmap
Date: Thu, 26 Jun 2008 22:19:00 +0200
Message-Id: <1214511542-28458-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a new interface /sys/firmware/memmap to export
the BIOS (Firmware) provided memory map via sysfs for usage with
kexec.

While the first patch adds the generic interface, the second patch
implements that interface for E820 on x86.

Change compared to previous commit:

 1. Added Greg KH to Cc as suggested by H. Peter Anvin to review sysfs
    structure.
 
 2. Display the configuration option only if CONFIG_EMBEDDED is set.
    If not, default to including the code in any case as it is not only
    useful for kexec.

Please review!


Signed-off-by: Bernhard Walle <bwalle@suse.de>



