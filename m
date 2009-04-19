Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZDSTA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZDSTA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 15:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZDSTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 15:00:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:40271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbZDSTAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 15:00:46 -0400
Date: Sun, 19 Apr 2009 19:00:44 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.1
Message-ID: <20090419190044.GA1493@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 19:00:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As there have been a few minor fixes pending for a while now, I thought
it was time to release 2.4.37.1. Most of these fixes concern minor
security issues which have been backported from 2.6 (mostly local DoSes).
In my opinion, only people with local users might consider upgrading, if
those people still exist !

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.1.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.1

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git


Reminder for those who are still unaware of it : 2.6.27 will be maintained
for years and is already quite stable. If you're still running 2.4 without
any particular reason, please give 2.6.27-stable a try and report any
regression, should you face any.

Regards,
Willy

--

Summary of changes from v2.4.37 to v2.4.37.1
============================================

Alan Cox (1):
      af_rose/x25: Sanity check the maximum user frame size

Oleg Nesterov (2):
      exit_notify: kill the wrong capable(CAP_KILL) check
      copy_process: fix CLONE_PARENT && parent_exec_id interaction

Serge E. Hallyn (1):
      CAP_FS_MASK: add CAP_LINUX_IMMUTABLE and CAP_MKNOD

Willy Tarreau (4):
      ATM: ensure we don't listen twice on a socket
      scripts: backport checkpatch.pl from mainline 2.6
      net: Fix soft lockups/OOM issues w/ unix garbage collector (CVE-2008-5300)
      Change VERSION to 2.4.37.1

