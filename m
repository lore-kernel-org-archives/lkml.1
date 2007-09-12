Return-Path: <linux-kernel-owner+w=401wt.eu-S1765550AbXILLaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765550AbXILLaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764812AbXILL3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:29:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49607 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbXILL3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:29:39 -0400
Subject: Re: [PATCH] free_irq(): Actually handle DEBUG_SHIRQ
From: David Woodhouse <dwmw2@infradead.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64N.0709121122120.24030@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709121122120.24030@blysk.ds.pg.gda.pl>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 13:29:36 +0200
Message-Id: <1189596576.3570.10.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 12:17 +0100, Maciej W. Rozycki wrote:
> Code used for DEBUG_SHIRQ in free_irq() is unreachable -- the for()
> loop within never terminates otherwise than by return.  This is an
> obvious fix.

Yeah... except that it enables new debugging code which (due to my
stupidity) wasn't enabled before. A fix for this is already in the -mm
tree, to be merged (along with a corresponding lockdep-related fix)
after 2.6.23 release.

-- 
dwmw2

