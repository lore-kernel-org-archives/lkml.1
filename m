Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYBXU70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYBXU70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYBXU7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:59:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:53718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbYBXU7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:59:17 -0500
Date: Sun, 24 Feb 2008 20:59:14 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.2
Message-ID: <20080224205914.GA18170@hera.kernel.org>
Reply-To: w@1wt.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.2. It reverts a fix from .1 which
causes lockups for some people when listing directories on ext2. The
only other fix is for vulnerability CVE-2007-6694 which might affect
CHRP platforms (powerpc).

Those who have already upgraded to 2.4.36.1 should upgrade again.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.2.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.2

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git


Regards,
Willy

---

Summary of changes from v2.4.36.1 to v2.4.36.2
============================================

Willy Tarreau (2):
      Revert "ext2_readdir() filp->f_pos fix"
      Change VERSION to 2.4.36.2

dann frazier (1):
      2.4: [POWERPC] CHRP: Fix possible NULL pointer dereference

