Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbXKSXMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbXKSXMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbXKSXMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:12:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48544 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbXKSXMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:12:30 -0500
Date: Mon, 19 Nov 2007 15:05:19 -0800
From: Greg KH <greg@kroah.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Michael Krufky <mkrufky@linuxtv.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 04/26] writeback: dont propagate
	AOP_WRITEPAGE_ACTIVATE
Message-ID: <20071119230519.GC25140@kroah.com>
References: <20071119181438.617190424@mini.kroah.org> <20071119181825.GE15425@kroah.com> <Pine.LNX.4.64.0711191852070.14717@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711191852070.14717@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 07:04:57PM +0000, Hugh Dickins wrote:
> On Mon, 19 Nov 2007, Greg Kroah-Hartman wrote:
> > 
> > 2.6.22-stable review patch.  If anyone has any objections, please let us
> > know.
> > 
> > ------------------
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > patch e423003028183df54f039dfda8b58c49e78c89d7 in mainline.
> > 
> > This is a writeback-internal marker but we're propagating it all the way back
> > to userspace!.
> > 
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> It's fine by me that this should go into 2.6.22-stable, but then please
> also put in this related patch from 2.6.23-stable: it's arguable whether
> either are strictly needed (they were originally provoked by unionfs, in
> Ubuntu but not mainline), but more helpful to include than exclude them.
> 
> Thanks,
> Hugh
> 
> 
> Subject: [patch 12/13] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE

Ok, thanks, I've added this patch to the queue too.

greg k-h
