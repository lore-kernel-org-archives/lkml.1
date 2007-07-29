Return-Path: <linux-kernel-owner+w=401wt.eu-S934363AbXG2TsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363AbXG2TsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762775AbXG2TsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:48:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761053AbXG2TsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:48:00 -0400
Subject: Re: [2.6 patch] kernel/audit.c: change the exports to
	EXPORT_SYMBOL_GPL
From: Arjan van de Ven <arjan@infradead.org>
To: Marcus Meissner <meissner@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, linux-audit@redhat.com
In-Reply-To: <20070729193339.GA29518@suse.de>
References: <20070729150233.GX16817@stusta.de>
	 <1185734433.346.33.camel@laptopd505.fenrus.org>
	 <20070729193339.GA29518@suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 29 Jul 2007 12:45:38 -0700
Message-Id: <1185738338.2686.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 21:33 +0200, Marcus Meissner wrote:
> On Sun, Jul 29, 2007 at 11:40:33AM -0700, Arjan van de Ven wrote:
> > On Sun, 2007-07-29 at 17:02 +0200, Adrian Bunk wrote:
> > > This patch changes some completely unused audit exports from 
> > > EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.
> > > 
> > > They are still completely unused, but hopefully some of the theoretical 
> > > code that might use it will appear in the kernel in the near future...
> 
> AppArmor uses the audit_log_* functions. 

but it's not in the tree. So marking them _UNUSED_ in the tree is still
appropriate. They're there for the people who want them, they're not
there for those who want to save the space....


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

