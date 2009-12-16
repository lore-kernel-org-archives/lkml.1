Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZLPOgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZLPOgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbZLPOgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:36:11 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59843 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbZLPOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=VKQchv4+xQsrfnEVboJ+jLFK5kmD7ip98H8fEBzUAwIGNYJa4FXu3XCbIEN+MyfzXw
         sPLs62Yqojy8cU4NhC3jxhc37Mdqec3cwY2hH/1cNyS6wGsnIsVWL0SAxznrswVqCHen
         X7jsyE5KGp2/6xo76vM4XsotNhmwqZukKoJp4=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 22:35:56 +0800
Message-Id: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.

Yong Zhang (5):
 aha152x: use DECLARE_COMPLETION_ONSTACK for non-constant completion
 mISDN: use DECLARE_COMPLETION_ONSTACK for non-constant completion
 USB: use DECLARE_COMPLETION_ONSTACK for non-constant completion
 hwmon: use DECLARE_COMPLETION_ONSTACK for non-constant completion
 powerpc/iseries: use DECLARE_COMPLETION_ONSTACK for non-constant completion

 arch/powerpc/platforms/iseries/viopath.c |    2 +-
 drivers/hwmon/ams/ams-pmu.c              |    4 ++--
 drivers/isdn/mISDN/l1oip_core.c          |    2 +-
 drivers/scsi/aha152x.c                   |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c          |    2 +-
 drivers/usb/gadget/fsl_udc_core.c        |    2 +-
 drivers/usb/gadget/langwell_udc.c        |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)
