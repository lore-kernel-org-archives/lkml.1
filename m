Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbYFBRlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbYFBRlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbYFBRix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:38:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14492 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758291AbYFBRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:38:52 -0400
Date: Mon, 2 Jun 2008 21:38:51 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] [POWERPC] 86xx: mpc8610_hpcd: add watchdog node
Message-ID: <20080602173851.GH30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/boot/dts/mpc8610_hpcd.dts |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8610_hpcd.dts b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
index fa9c297..bb0395b 100644
--- a/arch/powerpc/boot/dts/mpc8610_hpcd.dts
+++ b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
@@ -204,6 +204,11 @@
 			fsl,has-rstcr;
 		};
 
+		wdt@e4000 {
+			compatible = "fsl,mpc8610-wdt";
+			reg = <0xe4000 0x100>;
+		};
+
 		i2s@16000 {
 			compatible = "fsl,mpc8610-ssi";
 			cell-index = <0>;
-- 
1.5.5.1
