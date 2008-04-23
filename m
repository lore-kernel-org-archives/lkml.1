Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYDWJ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYDWJ7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYDWJwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:52:50 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36954 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbYDWJwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:52:49 -0400
Date: Wed, 23 Apr 2008 12:52:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "David S. Miller" <davem@sunset.davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport proc_clear_tty
Message-ID: <20080423095210.GF28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the removal of the Solaris binary emulation the export of 
proc_clear_tty became unused.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3cceb085820712e0df2916c89458bcc1ab04f250 diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 4d3c701..fb5a5cc 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -4037,7 +4037,6 @@ void proc_clear_tty(struct task_struct *p)
 	p->signal->tty = NULL;
 	spin_unlock_irq(&p->sighand->siglock);
 }
-EXPORT_SYMBOL(proc_clear_tty);
 
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {

