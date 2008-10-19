Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbYJSWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbYJSWQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYJSWQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:16:33 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:41717 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751922AbYJSWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:16:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Content-Disposition:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=WA6cdVvA2KfS22h4bkC1RvyRtlOHviUBNnLm/cmO+gaIqV/yPzT7bVwfRpXkZ9qN1vnCU+bE/PQG34A6LPjjOc1UCsLaNQlevDWwah20lWLUoAKyQZA0UCOm0yNiT0Rlzc6UK94G9FawO5njxFLiOjXXZKb7AFdcOmuyPkSX6B0=  ;
X-YMail-OSG: t3fu9hIVM1nDizKiQV9XYNfvbsb9WK5DUWS0iKCusFfNWQvNDWk9v4wFgschJZEJrlZnwjFLsG4T5EM32N2GkmPHFS0kZxtDdkH4QTwFLPcSuJv8lgqBZ7aNLGZufqDVUcVvNhfxkceL8fIFdpUxkwIo3zeri4JWvPhdb81j1WFraQ.G31aXgJg31SOW
X-Yahoo-Newman-Property: ymail-3
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
To: linux-mtd@lists.infradead.org
Subject: [PATCH 1/3] mtd m25p80: add support for Macronix MX25L12805D
Date: Sun, 19 Oct 2008 15:16:30 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <200810191516.30804.david-b@pacbell.net>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>

Support one more flavor of SPI flash:  Macronix MX25L12805D
(128 Mbit, 16 MByte).

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -467,6 +467,9 @@ static struct flash_info __devinitdata m25p_data [] = {
 	{ "at26df161a", 0x1f4601, 64 * 1024, 32, SECT_4K, },
 	{ "at26df321",  0x1f4701, 64 * 1024, 64, SECT_4K, },
 
+	/* Macronix */
+	{ "mx25l12805d", 0xc22018, 64 * 1024, 256, SECT_4K, },
+
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
 	 */


