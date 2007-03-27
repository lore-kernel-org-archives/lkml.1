Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXC0QYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXC0QYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXC0QYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:24:53 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:58973 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933012AbXC0QYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:24:52 -0400
Subject: [GIT PATCH] SCSI bug fixes for 2.6.21-rc5
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 11:24:37 -0500
Message-Id: <1175012677.3737.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly basic rollup of 3 basic double free or oops based bug
fixes.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The Short Changelog is

Joerg Dorchain (1):
      gdth: fix oops in gdth_copy_cmd()

Judith Lebzelter (1):
      mptsas: Fix oops for insmod during kexec

Linas Vepstas (1):
      lpfc: avoid double-free during PCI error failure

and the diffstat:

 message/fusion/mptsas.c |    7 +++++--
 scsi/gdth.c             |    2 ++
 scsi/lpfc/lpfc_init.c   |    5 ++---
 3 files changed, 9 insertions(+), 5 deletions(-)

James


