Return-Path: <linux-kernel-owner+w=401wt.eu-S1762368AbZCTXUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762368AbZCTXUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZCTXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:56 -0400
Received: from kroah.org ([198.145.64.141]:53188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759684AbZCTXNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:12 2009
Message-Id: <20090320222711.994532821@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, grant.likely@secretlab.ca,
       afleming@freescale.com, linuxppc-dev@ozlabs.org,
       Johns Daniel <johns.daniel@gmail.com>
Subject: [patch 19/32] powerpc: Remove extra semicolon in fsl_soc.c
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-remove-extra-semicolon-in-fsl_soc.c.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johns Daniel <jdaniel@computer.org>

TSEC/MDIO will not work with older device trees because of a semicolon
at the end of a macro resulting in an empty for loop body.

This fix only applies to 2.6.28; this code is gone in 2.6.29, according
to Grant Likely!

Signed-off-by: Johns Daniel <johns.daniel@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/powerpc/sysdev/fsl_soc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -255,7 +255,7 @@ static int __init gfar_mdio_of_init(void
 		gfar_mdio_of_init_one(np);
 
 	/* try the deprecated version */
-	for_each_compatible_node(np, "mdio", "gianfar");
+	for_each_compatible_node(np, "mdio", "gianfar")
 		gfar_mdio_of_init_one(np);
 
 	return 0;


