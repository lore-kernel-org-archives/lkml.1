Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZD0Lal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZD0Lal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZD0Lab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:30:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZD0Lab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:30:31 -0400
Date: Mon, 27 Apr 2009 07:30:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Message-ID: <20090427113030.GA3681@infradead.org>
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <1240821139-7247-24-git-send-email-monstr@monstr.eu> <1240821139-7247-25-git-send-email-monstr@monstr.eu> <1240821139-7247-26-git-send-email-monstr@monstr.eu> <1240821139-7247-27-git-send-email-monstr@monstr.eu> <1240821139-7247-28-git-send-email-monstr@monstr.eu> <1240821139-7247-29-git-send-email-monstr@monstr.eu> <1240821139-7247-30-git-send-email-monstr@monstr.eu> <20090427095815.GA12323@infradead.org> <49F58A87.5020405@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F58A87.5020405@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 12:35:51PM +0200, Michal Simek wrote:
> types and I would like to know about more info.
> For example
> If make sense long long	type for st_blocks. IMHO unsigned will be better.
> And I would like to create new stat64 structure where is not a fault for both noMMU/MMU version.
> In noMMU implementation is st_blocks unsigned long. Is it OK? or unsigned long long is better?

You want unsigned long long for it.  Take a look at e.g. the xtensa
stat.h and just reuse that one.  We should probaly create an
asm-generic/stat.h that new architectures can simply use..

Given that microblaze only got merged in the 2.6.30 window I would
suggest fixing up the nommu variant.
