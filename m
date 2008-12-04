Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYLDB12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYLDB12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLDB1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:27:20 -0500
Received: from ozlabs.org ([203.10.76.45]:47806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYLDB1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:27:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Yet more ARM breakage in linux-next
Date: Thu, 4 Dec 2008 11:57:14 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081203192905.GA12502@flint.arm.linux.org.uk> <200812040952.44957.rusty@rustcorp.com.au> <49371848.2080804@oracle.com>
In-Reply-To: <49371848.2080804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812041157.15355.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 10:07:44 Randy Dunlap wrote:
> Rusty Russell wrote:
> > (Yes, classic useless kerneldoc documentation doesn't actually *say*
> > this clearly).
>
> oh fud.  That's not a fault of kernel-doc, just of whoever wrote it.
> It's only as good as someone makes it.

Sorry that this came out wrong.  kernel-doc provides structure, but it can't 
provide content.  And authors seem unable to think from the POV of someone 
*using* the API.

With some work, I tracked it back to Stephen Hemminger for this comment in 
12d9c8420b9daa1da3d9e090640fb24bcd0deba2.  It's since been fixed and moved,
but it's still:

 * __fls: find last set bit in word
 * @word: The word to search
 *
 * Undefined if no set bit exists, so code should check against 0 first.

Which would be *fine* if fls() didn't have such confusing bit numbering and 
the exact same one-line description.

Thanks,
Rusty.
