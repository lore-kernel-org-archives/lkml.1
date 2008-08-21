Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYHUNhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYHUNhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYHUNhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:37:00 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51195 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752272AbYHUNg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:36:59 -0400
Date: Thu, 21 Aug 2008 09:36:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Lacombe <tuxiko@free.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXT3-fs error
Message-ID: <20080821133655.GG16634@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Lacombe <tuxiko@free.fr>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200808211106.39574.tuxiko@free.fr> <20080821104626.0a10f40c@lxorguk.ukuu.org.uk> <200808211302.55530.tuxiko@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808211302.55530.tuxiko@free.fr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 01:02:55PM +0200, Eric Lacombe wrote:
> > Might be worth running memtest86 on the box overnight and seeing if its
> > memory or other problems. smartmontools will give you info on the disk
> > status (as the disk sees it) which can sometimes give clues.
> 
> I will run memtest86 very soon. But in the meantime my computer just crashed.
> The logs are presented below (I know that the module nvidia is loaded, but I 
> never have problem with it before.).
> I remark that a general protection fault occur, and I saw a lot of them 
> recently (see also the second log trail for another error 2 hours earlier). 

I would definitely run memtest86 very soon, and if that doesn't work,
I'd try running for a little while without the nvidia driver.  I know
you say it hasn't given you any trouble, but it's always good to rule
out problems.  The sort of errors which you are reporting do make me
very suspicious about some kind of memory fault, though.  (Either
hardware induced or wild pointer induced, perhaps by some evil
binary-only module.  :-)

						- Ted
