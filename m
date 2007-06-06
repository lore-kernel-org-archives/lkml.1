Return-Path: <linux-kernel-owner+w=401wt.eu-S935864AbXFFUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864AbXFFUyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935061AbXFFUxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:53:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:41701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXFFUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:53:48 -0400
Date: Wed, 6 Jun 2007 20:53:47 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.34.5
Message-ID: <20070606205347.GA24188@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've just released Linux 2.4.34.5, with extracts from 2.4.35-pre5.
The most important one is the fix for the regression I introduced
while fixing CVE-2007-1353 (bluetooth). Basically, I turned a memory
leak bug into a memory corruption bug. Two minor bluetooth fixes have
all been backported from 2.6 too.

The other (less) important fix solves the problem of ide-disk.o causing
oopses after insmod, it was caused by init_idle() being erroneously
marked __init.

Last, a minor LVM fix from the RHEL3 kernel to correctly count extents
in case of errors during snapshot allocation.

Regards,
Willy

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.34.5.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.34.5

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.34.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.34.y.git



Summary of changes from v2.4.34.4 to v2.4.34.5
============================================

Willy Tarreau (6):
      do not mark init_idle() __init
      Bluetooth: correct fix for CVE-2007-1353
      [BACKPORT] Bluetooth: Fix NULL pointer dereference in HCI line discipline
      [BACKPORT] Bluetooth: Fix unintentional fall-through in HCI line discipline
      lvm: do not update extent count if snapshot allocation fails
      Change VERSION to 2.4.34.5

