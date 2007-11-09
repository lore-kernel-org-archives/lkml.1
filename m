Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbXKIXvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbXKIXvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbXKIXuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:50:55 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57260 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbXKIXuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:50:54 -0500
Message-id: <18101143033031832003.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 12/13] Char: nozomi, remove void acc char2 char3 more mp mp.c mp.yy m1 nozomi2 proto rej slock1 casts
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:50:54 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, remove void * casts

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 92ca82bcbd5dde95096dac24d0f6a9beab68e003
tree 748ac937f772410b364245897492b693491743f6
parent 1ab5d64fc4a2dd7a50b8971c67b9793511b4c47a
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 15:28:46 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:15:05 +0100

 drivers/char/nozomi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index e87ded2..0735df0 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1752,7 +1752,7 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 {
 	int rval = -EINVAL;
 	struct nozomi *dc = get_dc_by_tty(tty);
-	struct port *port = (struct port *)tty->driver_data;
+	struct port *port = tty->driver_data;
 	unsigned long flags;
 
 	/* DBG1( "WRITEx: %d, index = %d", count, index); */
@@ -1811,7 +1811,7 @@ exit:
  */
 static int ntty_write_room(struct tty_struct *tty)
 {
-	struct port *port = (struct port *)tty->driver_data;
+	struct port *port = tty->driver_data;
 	int room = 0;
 	struct nozomi *dc = get_dc_by_tty(tty);
 
@@ -1966,7 +1966,7 @@ static void ntty_put_char(struct tty_struct *tty, unsigned char c)
 /* Returns number of chars in buffer, called by tty layer */
 static s32 ntty_chars_in_buffer(struct tty_struct *tty)
 {
-	struct port *port = (struct port *)tty->driver_data;
+	struct port *port = tty->driver_data;
 	struct nozomi *dc = get_dc_by_tty(tty);
 	s32 rval;
 
