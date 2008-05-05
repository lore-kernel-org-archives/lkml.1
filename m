Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbYEESmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbYEESmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbYEESal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:30:41 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45004 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761615AbYEESaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:39 -0400
Date: Mon, 5 May 2008 21:29:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] unexport proc_clear_tty
Message-ID: <20080505182932.GY17139@cs181133002.pp.htv.fi>
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
Acked-by: David S. Miller <davem@davemloft.net>

---

This patch has been sent on:
- 23 Apr 2008

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

