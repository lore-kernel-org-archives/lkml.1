Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbYBLHHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbYBLHHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYBLHGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:06:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41457 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYBLHGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:06:53 -0500
Date: Mon, 11 Feb 2008 23:06:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: tytso@mit.edu, trond.myklebust@fys.uio.no, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080211230617.04806002@laptopd505.fenrus.org>
In-Reply-To: <20080211.220222.118805417.davem@davemloft.net>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<1202791555.20739.6.camel@heimdal.trondhjem.org>
	<20080212051136.GA12802@mit.edu>
	<20080211.220222.118805417.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 22:02:22 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Theodore Tso <tytso@mit.edu>
> Date: Tue, 12 Feb 2008 00:11:36 -0500
> 
> > __deprecate the old one,
> 
> Deprecate is garbage, shit hangs around in the tree forever
> and people just turn off the warnings.
> 
> Clean sweeps work much better, albeit with some merge pain,
> we'll cope.

I agree with that.

There is maybe a middle ground in this -next idea; 
as very first part of the series, the new api gets added, current users converted
and api marked __deprecated.

Then there's a second part to the patch, which is a separate tree, which gets
added at the very end, which removed the old api.

Both will go in at the same merge window, and the next-meister needs to track that
no new users show up... but the final tree allows this to be done somewhat more gentle.

Doesn't work for API changes that just change the API rather than extending it, and
doesn't solve the dependency issues. So I still think a cleansweep works best in general,
but I suspect Andrew just disagrees with that.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
