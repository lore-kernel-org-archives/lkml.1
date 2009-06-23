Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbZFWOai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbZFWOai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbZFWOaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:30:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50674 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbZFWOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:30:13 -0400
Date: Tue, 23 Jun 2009 16:30:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, liqin.chen@sunplusct.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: S+core architecture (arch/score/) support files
Message-ID: <20090623143012.GF6760@one.firstfloor.org>
References: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com> <200906231143.22985.arnd@arndb.de> <87zlbz17fb.fsf@basil.nowhere.org> <200906231555.54887.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906231555.54887.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:55:54PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 June 2009, Andi Kleen wrote:
> > IMHO a full successfull LTP run should be minimal criterium for
> > merging an architecture. That should catch most of the possible
> > "simple" mistakes in the syscall ABI. I would suggest to wait to after
> > this has been done.
> 
> I agree in general, but in this case the ABI is essentially defined
> through the asm-generic headers, with the exception of the functions

What I meant LTP would test if what you implemented works. Not that
you implement a particular ABI, just that the source level interface
works.

It's not a full test of course, but it's a reasonable sanity check over a wide
range of interfaces. When I was working on my architecture I found
it very helpful.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
