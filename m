Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYFAX3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYFAX3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYFAX1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:43684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbYFAX12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:28 -0400
Date: Sun, 1 Jun 2008 23:27:27 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.5
Message-ID: <20080601232727.GA11427@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Sun, 01 Jun 2008 23:27:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.5.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.5.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.5

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git

It fixes 3 medium vulnerabilities :
  - sit: Add missing kfree_skb() on pskb_may_pull() failure (CVE-2008-2136)
  - sparc: Fix mmap VA span checking (CVE-2008-2137)
  - old buffer overflow in moxa driver (CVE-2005-0504)

The remaining patches are minor backports and fixes.
Given the nature of the vulnerabilities, it is recommended to upgrade.

Regards,
Willy
--

Summary of changes from v2.4.36.4 to v2.4.36.5
============================================

David S. Miller (2):
      sit: Add missing kfree_skb() on pskb_may_pull() failure (CVE-2008-2136)
      sparc: Fix mmap VA span checking (CVE-2008-2137)

Gunnar Larisch (1):
      3c980-TX needs EXTRA_PREAMBLE

Li Zefan (1):
      ACPI: check a return value correctly in acpi_power_get_context()

Roel Kluin (1):
      wireless, airo: waitbusy() won't delay

Steve Rosenbluth (2):
      signal.h: use an explicit cast to silent compiler warnings
      fix build error with some flavours of gcc 2.95.3

Willy Tarreau (1):
      Change VERSION to 2.4.36.5

dann frazier (1):
      old buffer overflow in moxa driver (CVE-2005-0504)

