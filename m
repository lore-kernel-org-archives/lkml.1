Return-Path: <linux-kernel-owner+w=401wt.eu-S934235AbXFFMeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235AbXFFMeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762758AbXFFMeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:34:36 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36292 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762458AbXFFMef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:34:35 -0400
Subject: [PATCH] Minor cleanups in tty_ioctl.c
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070524160559.54c2c639@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 13:34:29 +0100
Message-Id: <1181133269.4096.34.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic stuff which annoyed me while I was poking at it...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index fd471cb..79e9c17 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -276,8 +276,8 @@ void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
 			ifound = i;
 		}
-	}
-	while(++i < n_baud_table);
+	} while(++i < n_baud_table);
+
 	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
 	/* Set exact input bits only if the input and output differ or the
@@ -437,7 +437,7 @@ static int set_termios(struct tty_struct * tty, void __user *arg, int opt)
 #endif
 
 	/* If old style Bfoo values are used then load c_ispeed/c_ospeed with the real speed
-	   so its unconditionally usable */
+	   so it's unconditionally usable */
 	tmp_termios.c_ispeed = tty_termios_input_baud_rate(&tmp_termios);
 	tmp_termios.c_ospeed = tty_termios_baud_rate(&tmp_termios);
 

-- 
dwmw2

