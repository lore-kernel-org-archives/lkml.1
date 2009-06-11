Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZFKR34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZFKR34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZFKR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:29:21 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:37466 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZFKR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:29:20 -0400
Message-Id: <670025478c2a687453cd1bac697d7d765843f59d.1244739994.git.keil@b1-systems.de>
In-Reply-To: <cover.1244739994.git.keil@b1-systems.de>
References: <cover.1244739994.git.keil@b1-systems.de>
Date: Thu, 11 Jun 2009 15:52:10 +0200
Subject: [PATCH 6/6] mISDN: cleanup mISDNhw.h
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused stuff.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 include/linux/mISDNhw.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/linux/mISDNhw.h b/include/linux/mISDNhw.h
index ce900f4..7f9831d 100644
--- a/include/linux/mISDNhw.h
+++ b/include/linux/mISDNhw.h
@@ -89,11 +89,6 @@ struct dchannel {
 	void			(*phfunc) (struct dchannel *);
 	u_int			state;
 	void			*l1;
-	/* HW access */
-	u_char			(*read_reg) (void *, u_char);
-	void			(*write_reg) (void *, u_char, u_char);
-	void			(*read_fifo) (void *, u_char *, int);
-	void			(*write_fifo) (void *, u_char *, int);
 	void			*hw;
 	int			slot;	/* multiport card channel slot */
 	struct timer_list	timer;
@@ -151,11 +146,6 @@ struct bchannel {
 	u_long			Flags;
 	struct work_struct	workq;
 	u_int			state;
-	/* HW access */
-	u_char			(*read_reg) (void *, u_char);
-	void			(*write_reg) (void *, u_char, u_char);
-	void			(*read_fifo) (void *, u_char *, int);
-	void			(*write_fifo) (void *, u_char *, int);
 	void			*hw;
 	int			slot;	/* multiport card channel slot */
 	struct timer_list	timer;
-- 
1.6.0.2

