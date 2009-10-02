Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZJBUMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZJBUMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbZJBUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:12:07 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:46274 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbZJBUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OS/pkd7Ks+5ucLOA+P1ZWhmrDMAB5m/iDqyr7BgjscO/6oQ0JaOlnVefhOvGWdqwKp
         buKfnrUOV7FhJK3OGef4ix0MXuKhRxNPVlBhcdUZmwjOoUux182nYmoRNV84xYwDaPly
         JIen41eS4J+VpqxdSDi/n5zFGSeTZYqYwvxyw=
Date: Sat, 3 Oct 2009 00:12:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] const: constify remaining tty_operations
Message-ID: <20091002201206.GA29905@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/xtensa/platforms/iss/console.c  |    2 +-
 drivers/char/bfin_jtag_comm.c        |    2 +-
 drivers/char/epca.c                  |    2 +-
 drivers/char/pcmcia/ipwireless/tty.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -196,7 +196,7 @@ static const struct file_operations rs_proc_fops = {
 	.release	= single_release,
 };
 
-static struct tty_operations serial_ops = {
+static const struct tty_operations serial_ops = {
 	.open = rs_open,
 	.close = rs_close,
 	.write = rs_write,
--- a/drivers/char/bfin_jtag_comm.c
+++ b/drivers/char/bfin_jtag_comm.c
@@ -226,7 +226,7 @@ bfin_jc_wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 }
 
-static struct tty_operations bfin_jc_ops = {
+static const struct tty_operations bfin_jc_ops = {
 	.open            = bfin_jc_open,
 	.close           = bfin_jc_close,
 	.write           = bfin_jc_write,
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -934,7 +934,7 @@ static int info_open(struct tty_struct *tty, struct file *filp)
 	return 0;
 }
 
-static struct tty_operations info_ops = {
+static const struct tty_operations info_ops = {
 	.open = info_open,
 	.ioctl = info_ioctl,
 };
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -603,7 +603,7 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 	}
 }
 
-static struct tty_operations tty_ops = {
+static const struct tty_operations tty_ops = {
 	.open = ipw_open,
 	.close = ipw_close,
 	.hangup = ipw_hangup,
