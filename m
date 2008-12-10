Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYLJSmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYLJSmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYLJSmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:42:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLJSmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:42:23 -0500
Message-ID: <49400D83.4060502@vlnb.net>
Date: Wed, 10 Dec 2008 21:42:11 +0300
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
Subject: [PATCH][RFC 8/23]: SCST pass-through backend handlers
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX184JZr+q0R9XSU6loJXm9SORi2nsyUrNe3GHfJ
 LoAF+Gc/jCE8p1w4BYPUw+qsuWk/tSm/2P+C9M/wU9Yog2gjA7
 L2EKv19au8fp+hB7kIT3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains SCST pass-through backend dev handlers. There are 
handlers for disks (type 0), tapes (type 1), processors (type 3), CDROMs 
(type 5), MO disks (type 7), medium changers (type 8) and RAID 
controllers (type 0xC).

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/dev_handlers/scst_cdrom.c       |  299 +++++++++++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_changer.c     |  229 ++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_dev_handler.h |  113 ++++++++++++++
  drivers/scst/dev_handlers/scst_disk.c        |  384 +++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_modisk.c      |  406 ++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_processor.c   |  229 ++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_raid.c        |  229 ++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_tape.c        |  426 +++++++++++++++++++++++++++++++++++++++++++++++++++++
  8 files changed, 2315 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_passthrough.diff



