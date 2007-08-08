Return-Path: <linux-kernel-owner+w=401wt.eu-S936500AbXHHD5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500AbXHHD5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934330AbXHHD5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:57:21 -0400
Received: from waste.org ([66.93.16.53]:47590 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbXHHD5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:57:20 -0400
Date: Tue, 7 Aug 2007 22:51:21 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [RFC][PATCH 1/5] pagemap: remove file header
Message-ID: <20070808035121.GL30556@waste.org>
References: <20070807223300.9228E0E0@kernel> <20070808011620.GF30556@waste.org> <20070808023100.222c4d15@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808023100.222c4d15@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 02:31:00AM +0100, Alan Cox wrote:
> O> > The endianness is only useful when examining a raw dump of
> > > pagemap from a different machine when you don't know the
> > > source of the file.  This is pretty rare, and the programs
> > > or scripts doing the copying off-machine can certainly be
> > > made to hold this information.
> 
> Nobody fancies doing bi-endian MIPS ?

Indeed not.
 
> > > The page size is available in userspace at least with libc's
> > > getpagesize().  This will also never vary across processes,
> 
> For now. Its a logical direction however thant we end up with bigger page
> sizes either by hardware or by software merging and end up having
> different page sizes for legacy 32bit binaries.

Blerch.

> > I'd really strongly prefer to have no header. It was added to
> > futureproof the thing.
> 
> The information needed to parse /proc/pid/pagemap can be stuck
> in /proc/pid/somewherelese. If we ever get page size variations and the
> like then /proc/pid/ is going to end up with that information anyway for
> ps and friends to use.

Well if somewhereelse doesn't exist today, programs written today will
break on tomorrow's kernels.

-- 
Mathematics is the supreme nostalgia of our time.
