Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXFOMky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXFOMky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXFOMks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:40:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3398 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752256AbXFOMkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:40:47 -0400
Date: Fri, 15 Jun 2007 12:40:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, holzheu@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070615124034.GH9442@ucw.cz>
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org> <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Your proposal is similar to one I made to some Japanese developers
> > earlier this year.  I was more modest, proposing that we
> > 
> > - add an enhanced printk
> > 
> > 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
>   Maybe a stupid idea but why do we want to assign these numbers by hand?
> I can imagine it could introduce collisions when merging tons of patches
> with new messages... Wouldn't it be better to compute say, 8-byte hash
> from the message and use it as it's identifier? We could do this

Why hashes? Just key it off full message, and treat it like normal
translation problem.

'lp%d: on fire' -> 'your printer failed basic tests, you should check
cabling'.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
