Return-Path: <linux-kernel-owner+w=401wt.eu-S933119AbYDVWZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbYDVWZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbYDVWYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:24:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42236 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342AbYDVWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:24:51 -0400
Date: Tue, 22 Apr 2008 15:12:12 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, herbert@gondor.apana.org.au,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: device_pm_add (was: Re: 2.6.25-git2: BUG: unable to handle
	kernel paging request at ffffffffffffffff)
Message-ID: <20080422221212.GB7792@kroah.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com> <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <200804222234.19936.rjw@sisk.pl> <alpine.LFD.1.10.0804221350110.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221350110.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:58:43PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > There is a bug in device_add() that IMO can be fixed this way:
> 
> Ok, looks fine. Greg?

No, the other patch from Rafael looks "more correct", I'd prefer that
one to go in.  I'm about to be away from email for probably 24 hours or
so, so if you could commit it, I'd appreciate it.

thanks,

greg k-h
