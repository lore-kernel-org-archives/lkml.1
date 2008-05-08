Return-Path: <linux-kernel-owner+w=401wt.eu-S932426AbYEHRqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbYEHRqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761798AbYEHRnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:33487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761353AbYEHRn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:28 -0400
Date: Thu, 8 May 2008 10:42:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 07/16] POWERPC: mpc5200: Fix unterminated of_device_id table
Message-ID: <20080508174211.GH855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-mpc5200-fix-unterminated-of_device_id-table.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Grant Likely <grant.likely@secretlab.ca>

commit bc775eac63c16dbcfabc4c6e949c0228edf3e11f upstream

If CONFIG_PPC_MPC5121 is not set, then the of_device_id table for the
mpc5200 serial driver will not get terminated with a NULL entry.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/mpc52xx_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -1221,8 +1221,8 @@ static struct of_device_id mpc52xx_uart_
 #endif
 #ifdef CONFIG_PPC_MPC512x
 	{ .compatible = "fsl,mpc5121-psc-uart", .data = &mpc512x_psc_ops, },
-	{},
 #endif
+	{},
 };
 
 static int __devinit

-- 
