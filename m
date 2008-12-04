Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYLDC4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYLDC4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYLDC4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:56:30 -0500
Received: from mail.vyatta.com ([76.74.103.46]:47101 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYLDC4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:56:30 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.386
Date: Wed, 3 Dec 2008 18:56:27 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Yet more ARM breakage in linux-next
Message-ID: <20081203185627.64fdb0fc@extreme>
In-Reply-To: <200812041157.15355.rusty@rustcorp.com.au>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
	<200812040952.44957.rusty@rustcorp.com.au>
	<49371848.2080804@oracle.com>
	<200812041157.15355.rusty@rustcorp.com.au>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008 11:57:14 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 04 December 2008 10:07:44 Randy Dunlap wrote:
> > Rusty Russell wrote:
> > > (Yes, classic useless kerneldoc documentation doesn't actually *say*
> > > this clearly).
> >
> > oh fud.  That's not a fault of kernel-doc, just of whoever wrote it.
> > It's only as good as someone makes it.
> 
> Sorry that this came out wrong.  kernel-doc provides structure, but it can't 
> provide content.  And authors seem unable to think from the POV of someone 
> *using* the API.
> 
> With some work, I tracked it back to Stephen Hemminger for this comment in 
> 12d9c8420b9daa1da3d9e090640fb24bcd0deba2.  It's since been fixed and moved,
> but it's still:
> 
>  * __fls: find last set bit in word
>  * @word: The word to search
>  *
>  * Undefined if no set bit exists, so code should check against 0 first.
> 
> Which would be *fine* if fls() didn't have such confusing bit numbering and 
> the exact same one-line description.
> 
> Thanks,
> Rusty.

I think the idea was that fls was supposed to match ffs which had stupid
bit numbering inherited from BSD. and __ffs and __fls were same
but undefined if word is 0 so that they could just be one line asm.
