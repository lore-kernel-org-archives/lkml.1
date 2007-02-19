Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbXBSMaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbXBSMaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXBSMaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:30:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53909 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbXBSM3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:29:51 -0500
Date: Mon, 19 Feb 2007 12:29:48 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Message-ID: <20070219122948.GA30602@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165751.5845.28503.sendpatchset@localhost.localdomain> <200702172214.55654.arnd@arndb.de> <20070218020429.GE1038@crusty.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218020429.GE1038@crusty.rchland.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 08:04:30PM -0600, Josh Boyer wrote:
> No, the MTD interface isn't flawed.  gluebi is present to make things like
> JFFS2 work on top of UBI volumes with very little adaptations.  If you go
> changing _every_ MTD user to now use either an MTD device or a native UBI
> device, then the code for those users just gets bloated.

That's not what Arnd means.  We really want only one mtd interface that
works transparently with both physical and stackable devices.  That means
instead of adding a new ubi interface you want to add support for stackable
devices to mtd.

