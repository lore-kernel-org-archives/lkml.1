Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYF0LM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYF0LM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYF0LMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:12:19 -0400
Received: from ns.suse.de ([195.135.220.2]:40860 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYF0LMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:12:18 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: gregkh@suse.de, kexec@lists.infradead.org, yhlu.kernel@gmail.com,
       vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: x86: Add /sys/firmware/memmap
Date: Fri, 27 Jun 2008 13:12:53 +0200
Message-Id: <1214565175-21512-1-git-send-email-bwalle@suse.de>
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

 1. Comments from Greg KH.
 2. Documentation.

The patch has been tested on i386 and x86_64 with success.


