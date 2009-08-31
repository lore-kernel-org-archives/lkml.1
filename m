Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZHaRVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZHaRVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZHaRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:21:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZHaRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:21:21 -0400
Date: Mon, 31 Aug 2009 13:21:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stefani Seibold <stefani@seibold.net>,
       Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-ID: <20090831172121.GA26558@infradead.org>
References: <1251563892.13287.11.camel@wall-e> <1251659144.20987.18.camel@wall-e> <20090831063334.GB7821@x200.localdomain> <200908311744.52972.arnd@arndb.de> <20090831171956.GA3036@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831171956.GA3036@x200.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 09:19:56PM +0400, Alexey Dobriyan wrote:
> After conversion, ->read_proc, ->write_proc, create_proc_read_entry(),
> create_proc_entry() will become deprecated for a while, then gone.

Just kill it once all intree users are gone, deprecation is only useful
if we still have some in-tree user around but want to keep people from
adding new ones.
