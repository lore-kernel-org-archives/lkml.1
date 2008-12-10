Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYLJSnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYLJSnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYLJSnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:43:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56601 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYLJSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:43:20 -0500
Message-ID: <49400DC8.6050209@vlnb.net>
Date: Wed, 10 Dec 2008 21:43:20 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 9/23]: SCST virtual disk backend handler
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18O5gu1VeyF4KDt5AJE8Y8qqE3YGCoKZWPgF0z
 1OWxP6jp3l3+q8+zVaqrbHpKVlt/zagepc0PLkqcYyAMrRf+lV
 asH3ABtk1033hjJmAhxLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the SCST virtual disk backend device handler. This
is an SCST device handler that allows to export local files or local
block devices as SCSI devices through the SCST target framework. This
handler has three modes:

  - FILEIO mode, which allows to use files on file systems or block 
devices as virtual remotely available SCSI disks or CDROMs with benefits 
of the Linux page cache.

  - BLOCKIO mode, which performs direct block IO with a block device, 
bypassing page-cache for all operations. This mode works ideally with 
high-end storage HBAs and for applications that either do not need 
caching between application and disk or need the large block throughput.

  - NULLIO mode, in which no real IO is performed. It is intended for 
performance testing.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/dev_handlers/scst_vdisk.c | 3540 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 3540 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_vdisk.diff



