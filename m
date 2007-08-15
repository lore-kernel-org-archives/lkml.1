Return-Path: <linux-kernel-owner+w=401wt.eu-S1764951AbXHOImd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764951AbXHOImd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbXHOIl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:41:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbXHOIlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:41:53 -0400
Date: Wed, 15 Aug 2007 08:41:48 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35.1
Message-ID: <20070815084148.GA16893@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.4.35.1.

This version includes some minor build fixes for people using GCC 4.x.
It now successfully builds with 4.2.

Please also note the security update : CVE-2007-3848. Limited impact, but
really depends on the setuid binaries provided by your distribution.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.35.1.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.35.1

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.35.y.git

Willy
--

Summary of changes from v2.4.35 to v2.4.35.1
============================================

Marc Haisenko (1):
      b44: fix force mac address before ifconfig up

Willy Tarreau (9):
      build fix for lvm with gcc 4
      fix wdt83627 build breakage with gcc 4.x
      wdt83627: fix wdt_init() return code
      module fdomain_cs requires fdomain_setup()
      do not use gcc's builtin strpbrk
      fix incorrect use of -fno-unit-at-a-time on GCC >= 4
      second build fix for some rare buggy versions of GCC 4
      CVE-2007-3848 Privilege escalation via PR_SET_PDEATHSIG
      Change VERSION to 2.4.35.1

