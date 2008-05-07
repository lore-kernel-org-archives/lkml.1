Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbYEGEdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbYEGEdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYEGEdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:33:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:34572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYEGEdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:33:32 -0400
Date: Wed, 7 May 2008 04:33:30 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.4
Message-ID: <20080507043330.GA19930@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.4.

This release fixes two local security issues discovered by
Al Viro who also provided these patches :
      CVE-2008-1669: Fix SMP ordering hole in fcntl_setlk()
      CVE-2008-1375: Fix dnotify/close race

Note that during the process, he noticed that an earlier fix
related to 1669 was already missing, so all users of 2.4 are
really encouraged to upgrade, or at least to apply those
patches to their own tree.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.4.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.4

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git

Regards,
Willy
----

Summary of changes from v2.4.36.3 to v2.4.36.4
============================================

Al Viro (1):
      Fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Willy Tarreau (2):
      Fix dnotify/close race (CVE-2008-1375)
      Change VERSION to 2.4.36.4

