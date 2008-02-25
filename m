Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYBYPkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYBYPkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYBYPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:40:05 -0500
Received: from brick.kernel.dk ([87.55.233.238]:20805 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbYBYPkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:40:02 -0500
Date: Mon, 25 Feb 2008 16:39:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Pinter <oliver.pntr@gmail.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: Re: [patch 07/23] cciss: Panic in blk_rq_map_sg() from CCISS driver
Message-ID: <20080225153958.GJ26812@kernel.dk>
References: <20080222213114.583282464@mini.kroah.org> <20080222214021.GH8686@suse.de> <1203951994.5046.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203951994.5046.2.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25 2008, Lee Schermerhorn wrote:
> On Fri, 2008-02-22 at 13:40 -0800, Greg KH wrote:
> > plain text document attachment
> > (cciss-panic-in-blk_rq_map_sg-from-cciss-driver.patch)
> > 2.6.22-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> Greg, Jens:  Does 2.6.22 contain the scatter/gather chaining that caused
> the problem in 23-rc6-mm1?  If not, I wouldn't think this patch is
> necessary there.

It doesn't, the patch is not needed.

-- 
Jens Axboe

