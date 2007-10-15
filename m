Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbXJOSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbXJOSdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbXJOSdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:33:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:47436 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbXJOSdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:33:14 -0400
Message-ID: <4713B238.4030409@windriver.com>
Date: Mon, 15 Oct 2007 13:32:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/21] KGDB: Request to merge KGDB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2007 18:33:08.0405 (UTC) FILETIME=[D53C1650:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request to merge KGDB into the mainline kernel.  

These KGDB patches are against the tip of kernel of the tree on
October 15, 2007.  I am continuing to update the for_mm branch against
the tip of the tree with the hope to merge KGDB into the kernel,
pending the review of the individual pieces.

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_mm


As of right now KGDB is comprised of 21 different patches adding in
the core api and docs first and then working up to add drivers and
arch specific support to KGDB.  The patches were broken down into
logical pieces for review and comments.

The intent of the KGDB patches is to unify the KGDB support across all
the architectures that elect to implement it KGDB functionality by
providing a common core and an arch specific stub.  For quite some
time there has been different features and uses of KGDB across the
most popular architectures.  Having a common core that takes care of
protocol parsing and the typical use case of software breakpoints
should eliminate the inconsistencies across the archs as well as
making it easier to add KGDB support to a new arch.

These KGDB patches include support for KGDB over ethernet and unify
the syntax and usage for setting up kgdb over rs232.

This series of KGDB patches covers the archs: i386, x86_64, ia64, arm,
mips, sh, ppc and powerpc.

After the merge of this patch set, any other arch can implement KGDB
support in the future by making use of the KGDB core by updating the
kgdb kconfig file and creating the arch specific stub.

Thanks,
Jason
