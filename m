Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZIRUfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZIRUfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZIRUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:35:12 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62904 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbZIRUfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:35:11 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linux-parisc@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 0/2] Linker script cleanup patches for parisc
Date: Fri, 18 Sep 2009 16:34:36 -0400
Message-Id: <1253306078-7066-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent on September 6
cleaning up the parisc architecture's linker scripts.  It differs from
the previous version only in having been rebased on top of Linus'
current master (and is a complete rewrite of the version that got some
review back in May:
<http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-05/msg00095.html>).

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (2):
  parisc: Clean up linker script using new linker script macros.
  parisc: Remove useless altinstructions code copied from x86.

 arch/parisc/kernel/vmlinux.lds.S |  104 ++------------------------------------
 1 files changed, 4 insertions(+), 100 deletions(-)

