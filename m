Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYBLWqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYBLWqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYBLWpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:45:55 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:44974 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYBLWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:45:53 -0500
Date: Tue, 12 Feb 2008 17:44:33 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, trond.myklebust@fys.uio.no,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212224433.GA9063@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	David Miller <davem@davemloft.net>, trond.myklebust@fys.uio.no,
	greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211.220222.118805417.davem@davemloft.net> <20080211230617.04806002@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211230617.04806002@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:06:17PM -0800, Arjan van de Ven wrote:
> There is maybe a middle ground in this -next idea; as very first
> part of the series, the new api gets added, current users converted
> and api marked __deprecated.
> 
> Then there's a second part to the patch, which is a separate tree,
> which gets added at the very end, which removed the old api.
> 
> Both will go in at the same merge window, and the next-meister needs
> to track that no new users show up... but the final tree allows this
> to be done somewhat more gentle.
> 
> Doesn't work for API changes that just change the API rather than
> extending it, and doesn't solve the dependency issues. So I still
> think a cleansweep works best in general, but I suspect Andrew just
> disagrees with that.

Yes, that's exactly what I was suggesting.  The __deprecate only lasts
for the merge window, and we remove the old API at the end of the
merge window.  So it's only there for a very short time, and it's only
there to make the cleen sweep a little less painful --- not one where
"shit hangs around in the tree forever".

					- Ted


