Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXLMOI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXLMOI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXLMOIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:08:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbXLMOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:08:18 -0500
From: Andre Haupt <andre@bitwigglers.org>
To: kernel-janitors@vger.kernel.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH][KJ] 8250: remove unnecessary variable tmout from  wait_for_xmitr()
Date: Thu, 13 Dec 2007 15:08:04 +0100
Message-Id: <11975548843528-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: n
References: n
X-Provags-ID: V01U2FsdGVkX1+T1J2jlcfBmYpCW3I2k2rBS6QMj5TnmnsdhpK
 jiUw2bvSMO3PehM1Pj17eSxXCYfzYgP8AUK1xo52WKEqJo2XZC
 6fUykeF27NlHZDeiFEREq6V7d1oyc7Gz5kyMbk1FN4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a sparse warning about symbol tmout shadowing an earlier one.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/serial/8250.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..284757d 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1727,7 +1727,6 @@ static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
 
 	/* Wait up to 1s for flow control if necessary */
 	if (up->port.flags & UPF_CONS_FLOW) {
-		unsigned int tmout;
 		for (tmout = 1000000; tmout; tmout--) {
 			unsigned int msr = serial_in(up, UART_MSR);
 			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
-- 
1.4.4.4

