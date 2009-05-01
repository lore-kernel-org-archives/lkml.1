Return-Path: <linux-kernel-owner+w=401wt.eu-S1763934AbZEARsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763934AbZEARsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZEARsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:48:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZEARr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:47:59 -0400
Date: Fri, 1 May 2009 13:47:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090501174757.GC8104@infradead.org>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241199689.13073.6.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 12:41:29PM -0500, Dave Kleikamp wrote:
> From: Andrew Tridgell <tridge@samba.org>
> Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
> 
> When this option is enabled the VFAT filesystem will refuse to create
> new files with long names. Accessing existing files with long names
> will continue to work.
> 
> File names to be created must conform to the 8.3 format.  Mixed case is
> not allowed in either the prefix or the suffix.

This doesn't make any sense as a compile time option. Might make sense
as a mount option, but I'd like to hear a rationale for it first.

