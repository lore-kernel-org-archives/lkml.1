Return-Path: <linux-kernel-owner+w=401wt.eu-S965147AbXAWOms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147AbXAWOms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965144AbXAWOmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:42:47 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:33877 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965156AbXAWOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:42:46 -0500
Message-id: <1335225196118637291@wsc.cz>
In-reply-to: <444432691808225221@wsc.cz>
Subject: [PATCH 3/3] Char: mxser_new, fix sparse warning
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <osv@javad.com>
Date: Tue, 23 Jan 2007 15:42:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, fix sparse warning

Feed NULL instead of 0 where pointer is expected.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>

---
commit e87e9f65c3ac51d447cfe435217032a07f7a56e0
tree fbb8597542ed5919d3fae6b9ab45865e0659e922
parent 76b3ee2d5737395df62553cec1b8193252476147
author Jiri Slaby <jirislaby@gmail.com> Tue, 23 Jan 2007 01:43:13 +0059
committer Jiri Slaby <jirislaby@gmail.com> Tue, 23 Jan 2007 01:43:13 +0059

 drivers/char/mxser_new.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index d52ecff..9af07e4 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -1708,7 +1708,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 
 		info->speed = speed;
 		spin_lock_irqsave(&info->slock, flags);
-		mxser_change_speed(info, 0);
+		mxser_change_speed(info, NULL);
 		spin_unlock_irqrestore(&info->slock, flags);
 
 		return 0;
