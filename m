Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXJaLSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXJaLSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXJaLSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:18:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36355 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbXJaLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:18:02 -0400
Date: Wed, 31 Oct 2007 12:18:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       nickpiggin@yahoo.com.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: NBD was Re: [PATCH 00/33] Swap over NFS -v14
Message-ID: <20071031111800.GA2551@elf.ucw.cz>
References: <20071030160401.296770000@chello.nl> <200710311426.33223.nickpiggin@yahoo.com.au> <20071030.213753.126064697.davem@davemloft.net> <20071031085041.GA4362@infradead.org> <1193828206.27652.145.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193828206.27652.145.camel@twins>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So please get the VM bits for swap over network blockdevices in first,
> 
> Trouble with that part is that we don't have any sane network block
> devices atm, NBD is utter crap, and iSCSI is too complex to be called
> sane.

Hey, NBD was designed to be _simple_. And I think it works okay in
that area.. so can you elaborate on "utter crap"? [Ok, performance is
not great.]

Plus, I'd suggest you to look at ata-over-ethernet. It is in tree
today, quite simple, but should have better performance than nbd.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
