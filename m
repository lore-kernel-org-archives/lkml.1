Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYGXMm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYGXMm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYGXMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:42:46 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54926 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYGXMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:42:45 -0400
Date: Thu, 24 Jul 2008 15:42:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC: 2.6 patch] clarify the WIRELESS_EXT_SYSFS help text
Message-ID: <20080724124225.GD32109@cs181140183.pp.htv.fi>
References: <20080724115805.5466c217@mjolnir.drzeus.cx> <1216899520.13587.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1216899520.13587.49.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 01:38:40PM +0200, Johannes Berg wrote:
> On Thu, 2008-07-24 at 11:58 +0200, Pierre Ossman wrote:
> > From commit 22bb1be4d27...:
> > 
> > "The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
> > by anyone."
> > 
> > Can't have been much of an investigation as HAL uses these to determine
> > if a card is a wireless one. Without this option, you cannot get
> > wireless support in NetworkManager, stranding most laptops.
> 
> Bzzzzt. You suck. Go check again. Hint: try hal's git tree.

Can everyone agree on the patch below?

> johannes

cu
Adrian


<--  snip  -->


Current Hal uses the CONFIG_WIRELESS_EXT_SYSFS files, so don't claim 
there were no known users and recommend to enable the option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

b685f62718b947264657c298e5ee5b2149200f68 
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index ab015c6..e582432 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -39,4 +39,4 @@ config WIRELESS_EXT_SYSFS
 	  files in /sys/class/net/*/wireless/. The same information
 	  is available via the ioctls as well.
 
-	  Say Y if you have programs using it (we don't know of any).
+	  If unsure, say Y.
