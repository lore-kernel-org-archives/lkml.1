Return-Path: <linux-kernel-owner+w=401wt.eu-S1946568AbXBIPiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946568AbXBIPiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946578AbXBIPfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946571AbXBIPfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ns6gAdXUp1yBbsEFmXycS9U/quocbGmezu0u0wzpvdDrI3EIpCwPNgqs/4OBUb650p3EDQe+RUh05fXv4zgtYkwQCjOh77Z+iZZDfEZxjZuZMi45BAvUm4NSETWwNnCxW3WDyV7r9rGsxRGY+Z67Gl//rfsE363yfCkjpDKh9DQ=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, ambx1@neo.rr.com
Subject: [PATCH 31/34] __initdata cleanup - pnp
Date: Fri, 9 Feb 2007 17:34:04 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091734.04628.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/pnp/pnpacpi/core.c linux-2.6.20-rc6-mm3/drivers/pnp/pnpacpi/core.c
--- linux-2.6.20-rc6-mm3.org/drivers/pnp/pnpacpi/core.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/pnp/pnpacpi/core.c	2007-01-31 22:19:30.000000000 +0200
@@ -236,7 +236,7 @@ static acpi_status __init pnpacpi_add_de
 	return AE_OK;
 }
 
-int pnpacpi_disabled __initdata;
+int pnpacpi_disabled __initdata = 0;
 static int __init pnpacpi_init(void)
 {
 	if (acpi_disabled || pnpacpi_disabled) {
