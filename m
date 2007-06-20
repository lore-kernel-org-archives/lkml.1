Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXFTPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXFTPh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXFTPhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:37:52 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:57300 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXFTPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:37:51 -0400
Date: Wed, 20 Jun 2007 11:37:32 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Add stack usage monitoring
Message-ID: <20070620153732.GC6728@c2.user-mode-linux.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org> <20070619115422.de61abd5.akpm@linux-foundation.org> <20070619195003.GA11718@c2.user-mode-linux.org> <20070619125707.84cf73fd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619125707.84cf73fd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:57:07PM -0700, Randy Dunlap wrote:
> Kconfig help text is indented 2 more spaces (by convention or
> CodingStyle).

OK, will fix.

> > +		if(*p != 0)
> 
> 		if (*p != NULL)

p is int *, so that's a int version pointer comparision.

> or
> 		if (*p)

Conceptually, p is an int, not a boolean, so I prefer to type the
extra characters to do the int-to-boolean conversion in places that
want booleans.

> > +	if (left < lowest_to_date) {
> > +		printk("Greatest stack depth - %d bytes left\n", left);
> 
> Does UML need/use KERN_* facility levels in printk() calls?

Yes, will fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
