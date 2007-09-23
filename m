Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXIWWUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXIWWUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXIWWUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:20:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:48391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbXIWWUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:20:44 -0400
Date: Sun, 23 Sep 2007 22:20:41 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35.3
Message-ID: <20070923222041.GA26070@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.35.3.

This version fixes CVE-2007-4573 which may lead to local privilege escalation
on x86_64.

It also fixes another problem reported by Gilles Espinasse: If the ATM module
is loaded with CLIP support but the CLIP module is not loaded yet, any user
reading /proc/net/atm/arp would cause a kernel panic to occur. 

Both x86_64 and ATM users are encouraged to upgrade. Note that USB DSL modems
often use ATM.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.35.3.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.35.3

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.35.y.git

Willy

-------

Summary of changes from v2.4.35.2 to v2.4.35.3
============================================

Andi Kleen (1):
      x86_64: Make sure to validate all 64bits of ptrace information

Stephen Hemminger (1):
      Bridge STP timer fixes

Willy Tarreau (2):
      ATM: avoid kernel panic upon access to /proc/net/atm/arp
      Change VERSION to 2.4.35.3

