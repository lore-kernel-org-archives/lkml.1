Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYIBV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYIBV1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYIBV1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:27:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:58488 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYIBV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xQGGasZYh/KGA+oXVm2H5ahqnuxNDF8hm/cotbgmNqc12+LfQMgHyyUtIu7s1KmRBD
         1sdzqF/qrfqBlYrDPgzbbiz05ZgIs+On+y4gFlgdjag6wtjrrhQ6MLSxDNtAcA0fGWWY
         zPSimpJi1gwY8kWtqx5ZLJy3HQC0USVVKfDdM=
Subject: [PATCH] tty: remove unused variable canon_change
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 02 Sep 2008 14:27:21 -0700
Message-Id: <1220390841.2137.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/tty_ioctl.c: In function ‘change_termios’:
drivers/char/tty_ioctl.c:492: warning: unused variable ‘canon_change’

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
new warning in next-20080902

 drivers/char/tty_ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 17e6a98..a408c8e 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -489,7 +489,6 @@ EXPORT_SYMBOL(tty_termios_hw_change);
 
 static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
-	int canon_change;
 	struct ktermios old_termios;
 	struct tty_ldisc *ld;
 	unsigned long flags;
-- 
1.6.0.1.400.ga23d3



