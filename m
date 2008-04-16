Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbYDPF0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbYDPF0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYDPF0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:26:00 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63809 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbYDPFZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:25:59 -0400
Date: Wed, 16 Apr 2008 01:25:45 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-kernel@vger.kernel.org, Marc Pignat <marc.pignat@hevs.ch>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] atmel_serial remove duplicated macro definition
Message-ID: <20080416012545.2709e7b7@siona.local>
In-Reply-To: <370563.4572.qm@web26213.mail.ukl.yahoo.com>
References: <370563.4572.qm@web26213.mail.ukl.yahoo.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 22:51:53 +0000 (GMT)
Michael Trimarchi <trimarchimichael@yahoo.it> wrote:

> After commit 39d4c922b596633da86878b1a5cc881785b8e5fa (atmel_serial: fix
> uart/console concurrent access) the UART_GET_TCR macro got redefined. This
> patch removes the duplicated definition.

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Original attachment follows...

=============[cut here]===================

After commit 39d4c922b596633da86878b1a5cc881785b8e5fa (atmel_serial: fix
uart/console concurrent access) the UART_GET_TCR macro got redefined. This
patch removes the duplicated definition.

Signed-off-by: michael trimarchi <trimarchimichael@evidence.eu.com>
---
 drivers/serial/atmel_serial.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 430997e..3a5f44c 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -96,7 +96,6 @@
 
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
-#define UART_GET_TCR(port)      __raw_readl((port)->membase + ATMEL_PDC_TCR)
 #define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
 
 #define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
-- 
1.5.3.1

