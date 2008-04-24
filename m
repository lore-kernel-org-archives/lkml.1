Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbYDXTpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbYDXTpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbYDXTo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:44:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbYDXTo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:44:58 -0400
Date: Thu, 24 Apr 2008 15:44:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: linux-next: Tree for April 24
Message-ID: <20080424194457.GA22805@infradead.org>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au> <Pine.LNX.4.64.0804242136420.21224@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804242136420.21224@anakin>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 09:40:15PM +0200, Geert Uytterhoeven wrote:
> On Thu, 24 Apr 2008, Stephen Rothwell wrote:
> > Status of my local build tests will be at
> > http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> > advice about cross compilers/configs that work, we are always open to add
> > more builds.
> 
> For the second day in a row, m68k builds failed because of
> 
>     fs/xfs/xfs_fsops.c:527: error: implicit declaration of function 'xfs_icsb_sync_counters_locked'
>     make[3]: *** [fs/xfs/xfs_fsops.o] Error 1

Eric already submitted a patch on the xfs list, that should make it to
the tree ASAP.

