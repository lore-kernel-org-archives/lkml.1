Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbXFFPCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbXFFPCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXFFPCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:02:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbXFFPCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:02:35 -0400
Date: Wed, 6 Jun 2007 11:02:30 -0400
From: Dave Jones <davej@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: remove references to dead urls from mtd nand code.
Message-ID: <20070606150230.GA3089@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070606054647.GA20850@redhat.com> <1181116788.25232.404.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181116788.25232.404.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 08:59:48AM +0100, David Woodhouse wrote:

 > > - *	Additional technical information is available on
 > > - *	http://www.linux-mtd.infradead.org/tech/nand.html
 > 
 > And that one should be changed to match the working one (and possibly be
 > enclosed in <...> too for consistency, although I've never been very
 > fond of that convention.

Me either, lets keep it the way it is.

As reported in http://bugzilla.kernel.org/show_bug.cgi?id=7815
this URL 404's.  Fix it to point at the correct place.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 7e68203..6ede757 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -7,7 +7,7 @@
  *   Basic support for AG-AND chips is provided.
  *
  *	Additional technical information is available on
- *	http://www.linux-mtd.infradead.org/tech/nand.html
+ *	http://www.linux-mtd.infradead.org/doc/nand.html
  *
  *  Copyright (C) 2000 Steven J. Hill (sjhill@realitydiluted.com)
  *		  2002-2006 Thomas Gleixner (tglx@linutronix.de)


-- 
http://www.codemonkey.org.uk
