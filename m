Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbZEAVBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbZEAVBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZEAVBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:01:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZEAVBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:01:14 -0400
Date: Fri, 1 May 2009 17:01:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Andrew Tridgell <tridge@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090501210109.GA3079@infradead.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:18:20PM -0500, Steve French wrote:
> For those manufacturers who who would like to disable
> creation of long file names, but allow reading long file names,
> and handle FAT32 on disk format and maximum sizes, it seems
> reasonable to give them a simple configure option for it.  It is
> harder, and less effective, to make the corresponding change
> to modify the mount helper and kernel code to add
> a new mount option, because it can be bypassed trivially
> at the command line (ie having to "force" mount to pass a "nolongfilename"
> mount option, would be harder than a simple kernel configure option)

Steve, can you please stop the bullshitting?

>From the complete lack of technical arguments it's pretty obvious that
this seems to be some FUD fallout from the MS vs TomTom patent lawsuite.

I'm not a lawyer so I don't know how much of a threat it is.  But either
the case gets shot down by showing prior art and everything is fine, or
we indeed are in deep trouble and should remove it completely.  Given
the Cc list on here IBM seems to have some legal opinion on it, so can
we please see it and discuss what we want to with all cards on the
table?

