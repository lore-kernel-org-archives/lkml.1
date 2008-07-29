Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYG2CGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYG2CGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYG2CGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:06:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYG2CGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OUwtdUUdeKP1UL8T8Amn6FV3SodewCZjAuZnXgo7jjxmMw++LGNa93PaZnHwa0YQkY
         o4fDYSvjSLZ5fP2v7OybHPFQ57X8QTfhI6Cg0yb6BTwxw2eherIOMbtA3hBzSiRUC5Tk
         fogiMI25BMsrk1YN/Nh5q0fas50Cz7PfHr19Y=
Date: Tue, 29 Jul 2008 06:06:38 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
Subject: [PATCH 12/13] proc tty: remove ->read_proc from rfcomm
Message-ID: <20080729020638.GL3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/bluetooth/rfcomm/tty.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -1084,11 +1084,6 @@ static void rfcomm_tty_hangup(struct tty_struct *tty)
 	}
 }
 
-static int rfcomm_tty_read_proc(char *buf, char **start, off_t offset, int len, int *eof, void *unused)
-{
-	return 0;
-}
-
 static int rfcomm_tty_tiocmget(struct tty_struct *tty, struct file *filp)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
@@ -1147,7 +1142,6 @@ static const struct tty_operations rfcomm_ops = {
 	.send_xchar		= rfcomm_tty_send_xchar,
 	.hangup			= rfcomm_tty_hangup,
 	.wait_until_sent	= rfcomm_tty_wait_until_sent,
-	.read_proc		= rfcomm_tty_read_proc,
 	.tiocmget		= rfcomm_tty_tiocmget,
 	.tiocmset		= rfcomm_tty_tiocmset,
 };
-- 
1.5.4.5


