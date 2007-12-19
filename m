Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXLSLRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXLSLRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXLSLRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:17:33 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:3539 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124AbXLSLRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:17:32 -0500
X-Greylist: delayed 74819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2007 06:17:32 EST
From: Damien Wyart <damien.wyart@free.fr>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>,
       Peter Leckie <pleckie@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
References: <20071218112804.GA3069@localhost.localdomain>
	<20071218122445.GJ4396912@sgi.com> <877ijckrco.fsf@free.fr>
	<20071218151946.GQ4396912@sgi.com> <20071219104544.GC4612@sgi.com>
Date: Wed, 19 Dec 2007 12:17:30 +0100
In-Reply-To: <20071219104544.GC4612@sgi.com> (David Chinner's message of "Wed,
	19 Dec 2007 21:45:44 +1100")
Message-ID: <87r6hjaq7p.fsf@free.fr>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Chinner <dgc@sgi.com> [071219 11:45]:
> Can someone pass me a brown paper bag, please?

My first impression on this bug was not so wrong, after all ;-)

> That also explains why we haven't seen it - it requires the user
> buffer to fill on the first entry of a backing buffer and so it is
> largely dependent on the pattern of name lengths, page size and
> filesystem block size aligning just right to trigger the problem.

I guess I was lucky to trigger it quite easily...

> Can you test this patch, Damien?

Works fine, all the bad symptoms have disappeared and strace output is
normal.

So you can add:

Tested-by: Damien Wyart <damien.wyart@free.fr>

-- 
Damien
