Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbXG2Tds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbXG2Tds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765059AbXG2Tdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:33:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:54520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762158AbXG2Tdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:33:41 -0400
Date: Sun, 29 Jul 2007 21:33:39 +0200
From: Marcus Meissner <meissner@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@stusta.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [2.6 patch] kernel/audit.c: change the exports to EXPORT_SYMBOL_GPL
Message-ID: <20070729193339.GA29518@suse.de>
References: <20070729150233.GX16817@stusta.de> <1185734433.346.33.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185734433.346.33.camel@laptopd505.fenrus.org>
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:40:33AM -0700, Arjan van de Ven wrote:
> On Sun, 2007-07-29 at 17:02 +0200, Adrian Bunk wrote:
> > This patch changes some completely unused audit exports from 
> > EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.
> > 
> > They are still completely unused, but hopefully some of the theoretical 
> > code that might use it will appear in the kernel in the near future...

AppArmor uses the audit_log_* functions. (But it is GPL, so no worries).

Ciao, Marcus
