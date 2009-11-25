Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZKYL0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZKYL0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbZKYL0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:26:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:35623 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584AbZKYL0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:26:36 -0500
Date: Wed, 25 Nov 2009 12:26:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the trivial tree with the arm tree
In-Reply-To: <20091125182938.330219af.sfr@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.0911251220110.6953@wotan.suse.de>
References: <20091125182938.330219af.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/plat-mxc/include/mach/mx2x.h between commit
> b9fc90a48a3d1794443e095d8585dcaeafb2195f ("imx: add namespace prefixes
> for symbols in mx2x.h") from the arm tree and commit
> 324bea84dda5e6ddea9464cdd957cb8cf94552d9 ("tree-wide: fix typos "offest"
> -> "offset"") from the trivial tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks. Probably the easiest way here is to hand it over to Russel.

I have dropped it from my tree -- Russel, please consider applying the 
patch below. Thanks.


From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: [PATCH] arm: fix "offest" -> "offset" typo

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/arm/plat-mxc/include/mach/mx2x.h b/arch/arm/plat-mxc/include/mach/mx2x.h
index db5d921..728f31c 100644
--- a/arch/arm/plat-mxc/include/mach/mx2x.h
+++ b/arch/arm/plat-mxc/include/mach/mx2x.h
@@ -25,7 +25,7 @@
 
 /* The following addresses are common between i.MX21 and i.MX27 */
 
-/* Register offests */
+/* Register offsets */
 #define AIPI_BASE_ADDR          0x10000000
 #define AIPI_BASE_ADDR_VIRT     0xF4000000
 #define AIPI_SIZE               SZ_1M

