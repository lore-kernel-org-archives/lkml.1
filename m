Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYBLWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYBLWlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYBLWlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:41:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39637 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYBLWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:41:35 -0500
Date: Tue, 12 Feb 2008 22:41:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       davem@davemloft.net, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212224103.GK27894@ZenIV.linux.org.uk>
References: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212194100.GH27894@ZenIV.linux.org.uk> <20080212215152.1470fe7f@core> <20080212141726.1e214729.akpm@linux-foundation.org> <20080212222044.214ad821@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212222044.214ad821@core>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:20:44PM +0000, Alan Cox wrote:
> > I think the best way to get the serial drivers maintained would be to cat
> > them all onto the end of synclink.c and hope that Paul thinks he did it.
> 
> Well I've already broken the buffering so he'd fix it ;)
> 
> We have a pile of old ISA drivers that are going to break soon with the
> locking changes and a pile of USB drivers that when I looked at the
> locking were so terminally broken I couldn't be bothered to fix them.
> 
> So it'll be fun, lots of && BROKENs to add

Hrm...  How badly is pl2303 broken?  I actually use that sucker, so if
it needs help - count me in.
