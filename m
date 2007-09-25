Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbXIYE2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbXIYE2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXIYE2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:28:15 -0400
Received: from ozlabs.org ([203.10.76.45]:50102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbXIYE2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:28:14 -0400
Subject: Re: [PATCH] Delay creation of khcvd thread
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Blanchard <anton@au1.ibm.com>, paulus <paulus@au1.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, Dave Jones <davej@codemonkey.org.uk>
In-Reply-To: <20070925140454.566803e5.sfr@canb.auug.org.au>
References: <1190691984.27805.270.camel@localhost.localdomain>
	 <20070925140454.566803e5.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:27:41 +1000
Message-Id: <1190694461.27805.295.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 14:04 +1000, Stephen Rothwell wrote:
> On Tue, 25 Sep 2007 13:46:24 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > hvc_console used to only be for Power aka pSeries: now lguest and Xen
> 
> Also legacy iSeries :-)

OK, how's this:
---
HVC console is also used by iSeries, so add that to HVC_DRIVER help.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 85d39cbbd21c drivers/char/Kconfig
--- a/drivers/char/Kconfig	Tue Sep 25 14:23:07 2007 +1000
+++ b/drivers/char/Kconfig	Tue Sep 25 14:26:01 2007 +1000
@@ -569,7 +569,7 @@ config HVC_DRIVER
 	bool
 	help
 	  Generic "hypervisor virtual console" infrastructure for various
-	  hypervisors (pSeries, Xen, lguest).
+	  hypervisors (pSeries, iSeries, Xen, lguest).
 	  It will automatically be selected if one of the back-end console drivers
 	  is selected.
 


