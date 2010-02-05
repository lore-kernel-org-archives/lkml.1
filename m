Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab0BENwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:52:08 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:58412 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab0BENwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hjpJ6dtFbQBkg1BJLfDF25FKBZbB7znHw2975o958nzEnAB+2cCGc87KOigSo3LJ0/
         MOh2srxcwPUx5yEJLap9Wc3uhQ3s7qKPCIM3j9/KTRMquAm064PRwp/sZEQew7EpiHTf
         b2Rc7gfh+y6WXLuDLrE4uqTZCrandSm69Wsm8=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: [PATCH 0/4] correct onstack wait_queue_head declaration
Date: Fri,  5 Feb 2010 21:52:00 +0800
Message-Id: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Onstack wait_queue_head must be declared with
DECLARE_WAIT_QUEUE_HEAD_ONSTACK. Otherwise it will make lockdep
warn. So fix the wrong usage in this patchset.

BTW, I split it to 4 patches to send to different maintainer
though it's due to the same issue. If you have no objection
on this kind of fix, I can also send it in one patch for some
simplification.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Yong Zhang (4):
      dmaengine: correct onstack wait_queue_head declaration
      [SCSI] bfa: correct onstack wait_queue_head declaration
      V4L/DVB: gspca - sn9c20x: correct onstack wait_queue_head declaration
      Staging: rt2860: correct onstack wait_queue_head declaration

 drivers/dma/dmatest.c                |    2 +-
 drivers/media/video/gspca/sn9c20x.c  |    2 +-
 drivers/scsi/bfa/bfad_im.c           |    4 ++--
 drivers/staging/rt2860/rt_main_dev.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
