Return-Path: <linux-kernel-owner+w=401wt.eu-S968005AbXEHFk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968005AbXEHFk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968000AbXEHFkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:40:23 -0400
Received: from 1wt.eu ([62.212.114.60]:2525 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967999AbXEHFkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:40:23 -0400
Date: Tue, 8 May 2007 07:39:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070508053929.GH943@1wt.eu>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz> <1178550653.11851.191.camel@pmac.infradead.org> <20070507194949.GB3981@ucw.cz> <1178567497.11851.229.camel@pmac.infradead.org> <20070507203812.GA18400@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507203812.GA18400@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:38:12PM +0200, Pavel Machek wrote:
> On Mon 2007-05-07 20:51:37, David Woodhouse wrote:
> > On Mon, 2007-05-07 at 19:49 +0000, Pavel Machek wrote:
> > > We had this discussion before. Kernel sources should be us-ascii.
> > > utf-8 is ok for documentation. 
> > 
> > /* This _is_ documentation. Go away. */
> 
> No, that's a comment. Fix your code.
> 
> (And besides, comments are supposed to be useful. Patch contained
> something like...
> 
> int voltage; /* ??V */
> 
> ...which is pretty unhelpful. We still stick to 80 columns in the
> code, and bigger displays certainly predate utf-8 compatibility. Plus,
> you'd have to convert large part of Czech republic before I could
> reasonably use utf-8).
> 									Pavel

I agree that it's really sad that anyone applies his own caprice in source
code which is supposed to be used by anybody. Next time this crap will
appear in printks and we will say "hey, it's documentation". It would be
better to stick to the common denominator. Some people like Davem insist
a lot on respecting the 80 columns limit for good reason. We should also
respect the charset supported by the same terminals.

Otherwise, if anything is allowed in comments, I don't see why we should
not start to put ASCII art "just for fun", since I do not see any justified
use of the UTF8 on the code above.

And no, I won't upgrade my system to get UTF8 support.

Willy

