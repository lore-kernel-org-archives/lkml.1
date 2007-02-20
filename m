Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbXBTRn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbXBTRn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932959AbXBTRn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:43:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54429 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbXBTRn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:43:57 -0500
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: John Stoffel <john@stoffel.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <17883.2878.998312.904061@jfsnew.stoffel.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <17883.2878.998312.904061@jfsnew.stoffel.org>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 11:44:58 -0600
Message-Id: <1171993498.24204.108.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 09:52 -0500, John Stoffel wrote:
> Artem> This patch-set contains UBI, which stands for Unsorted Block
> Artem> Images. This is closely related to the memory technology
> Artem> devices Linux subsystem (MTD), so this new piece of software is
> Artem> from drivers/mtd/ubi.
> 
> Can you define UBI in each and every file you create?  This is a

That is pretty pointless work.  It's expanded in the Kconfig menu, which
people need to select before using it anyway.

> Artem> In short, UBI is kind of LVM layer but for flash (MTD)
> Artem> devices. It makes it possible to dynamically create, delete and
> Artem> re-size volumes. But the analogy is not full. UBI also takes
> Artem> care of wear-leveling and bad eraseblocks handling, so UBI
> Artem> completely hides 2 aspects of flash chips which make them very
> Artem> difficult to work with:
> 
> Neat stuff!  Too bad you don't have a more descriptive name for it,
> UBI just doesn't seem to have any connection to LVM for Flash plus
> wear leveling.  

Given that it's contained under the MTD tree, it should be fairly
obvious it's flash related.  And the Kconfig help text for UBI
specifically mentions it's purpose and analogy to LVM.

josh

