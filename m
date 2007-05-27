Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXE0OwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXE0OwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 10:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXE0OwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 10:52:04 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33544 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXE0OwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 10:52:03 -0400
Date: Sun, 27 May 2007 10:52:00 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] SCSI/initio fixes, cleanups, PCI API support
Message-ID: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset presents the path to PCI API support in the initio driver.

But the first patch really begs the question:  Has this driver really
been broken since Oct 2003?  If so, let's just delete it.

 drivers/scsi/initio.c |  206 +++++++++++++++++++++++++++++---------------------
 drivers/scsi/initio.h |   10 +-
 2 files changed, 127 insertions(+), 89 deletions(-)

