Return-Path: <linux-kernel-owner+w=401wt.eu-S1750759AbXCGQVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759AbXCGQVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbXCGQVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:21:15 -0500
Received: from [198.99.130.12] ([198.99.130.12]:56824 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXCGQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:21:14 -0500
Date: Wed, 7 Mar 2007 11:11:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>, akpm@osdl.org
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH 4/5] UML - driver formatting fixes
Message-ID: <20070307161139.GA3345@ccure.user-mode-linux.org>
References: <200703061832.l26IWBKi006564@ccure.user-mode-linux.org> <200703062007.16943.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703062007.16943.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 08:07:16PM +0100, Blaisorblade wrote:
> The second line should better say -err instead of err.

Right, patch below.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


My last formatting patch got the sign of an error wrong in a printk.

Thanks to Blaisorblade for the close look.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test/arch/um/drivers/chan_user.c
===================================================================
--- test.orig/arch/um/drivers/chan_user.c	2007-03-06 12:10:12.000000000 -0500
+++ test/arch/um/drivers/chan_user.c	2007-03-07 11:14:12.000000000 -0500
@@ -158,7 +158,7 @@ static int winch_tramp(int fd, struct tt
 	 */
 	err = run_helper_thread(winch_thread, &data, CLONE_FILES, &stack, 0);
 	if(err < 0){
-		printk("fork of winch_thread failed - errno = %d\n", err);
+		printk("fork of winch_thread failed - errno = %d\n", -err);
 		goto out_close;
 	}
 
