Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815Ab0AaJg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0AaJg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 04:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867Ab0AaJg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 04:36:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:51756 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0AaJg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:36:27 -0500
Date: Sun, 31 Jan 2010 09:36:26 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.8
Message-ID: <20100131093626.GA25774@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 09:36:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just released Linux 2.4.37.8.

It mainly fixes a recently discovered vulnerability in the e1000 driver
which could allow a carefully crafted frame to bypass packet filtering
(CVE-2009-4536).

Users who don't run this driver probably don't need to upgrade.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.8.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.8

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git

Regards,
Willy
---

Summary of changes from v2.4.37.7 to v2.4.37.8
============================================

Jesse Brandeburg (1):
      e1000: enhance frame fragment detection (CVE-2009-4536)

Max Dmitrichenko (1):
      dmi: fix year parsing in dmi_check_blacklist()

Thomas Bork (1):
      scsi: fix error with 'scsi remove-single-device' in kernel 2.4.x

Willy Tarreau (3):
      tty: also mark the a2232 driver as broken
      Makefile: add the 'cscope' target.
      Change VERSION to 2.4.37.8

