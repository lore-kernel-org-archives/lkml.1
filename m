Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYBYR7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYBYR7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbYBYR7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:59:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60997 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270AbYBYR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:59:23 -0500
Date: Mon, 25 Feb 2008 09:55:08 -0800
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       torvalds@linux-foundation.org, Greg KH <gregkh@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 07/23] cciss: Panic in blk_rq_map_sg() from
	CCISS driver
Message-ID: <20080225175508.GC18940@kroah.com>
References: <20080222213114.583282464@mini.kroah.org> <20080222214021.GH8686@suse.de> <1203951994.5046.2.camel@localhost> <20080225153958.GJ26812@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225153958.GJ26812@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 04:39:58PM +0100, Jens Axboe wrote:
> On Mon, Feb 25 2008, Lee Schermerhorn wrote:
> > On Fri, 2008-02-22 at 13:40 -0800, Greg KH wrote:
> > > plain text document attachment
> > > (cciss-panic-in-blk_rq_map_sg-from-cciss-driver.patch)
> > > 2.6.22-stable review patch.  If anyone has any objections, please let us
> > > know.
> > 
> > Greg, Jens:  Does 2.6.22 contain the scatter/gather chaining that caused
> > the problem in 23-rc6-mm1?  If not, I wouldn't think this patch is
> > necessary there.
> 
> It doesn't, the patch is not needed.

Thanks for letting me know, the patch is now dropped.

greg k-h
