Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXCOWYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXCOWYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCOWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:29 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33703 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbXCOWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:27 -0400
Message-ID: <45F9BF3A.6090009@pathscale.com>
Date: Thu, 15 Mar 2007 14:48:42 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Description of the ipath patches I just sent
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My patch mailer decided to send them without a summary.  Oops.

This series is a variety of bugfixes and cleanups for the ipath driver. 
  It doesn't touch anything in IB-land.  The patches apply cleanly and 
run happily against 2.6.21-rc3.

  ipath_common.h    |   25 -
  ipath_cq.c        |   38 +
  ipath_debug.h     |    1
  ipath_diag.c      |   19
  ipath_driver.c    |  125 +++--
  ipath_eeprom.c    |    4
  ipath_file_ops.c  |  307 ++++++++------
  ipath_iba6110.c   |  154 ++++---
  ipath_iba6120.c   |   73 ++-
  ipath_init_chip.c |   88 ++--
  ipath_intr.c      |  100 +++-
  ipath_kernel.h    |   10
  ipath_keys.c      |   14
  ipath_mr.c        |   12
  ipath_qp.c        |  133 +++---
  ipath_rc.c        |  960 +++++++++++++++++++++++++-------------------
  ipath_registers.h |   22 -
  ipath_ruc.c       |   63 +-
  ipath_stats.c     |   16
  ipath_uc.c        |    6
  ipath_ud.c        |    8
  ipath_verbs.c     |   14
  ipath_verbs.h     |   57 +-
  23 files changed, 1387 insertions(+), 862 deletions(-)
