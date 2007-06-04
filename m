Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbXFDNR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbXFDNR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXFDNRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:17:21 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53263 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbXFDNRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:17:20 -0400
Date: Mon, 4 Jun 2007 15:17:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH] Fix roundup_pow_of_two(1)
Message-ID: <20070604131723.GV5500@stusta.de>
References: <200705172356.57620.eike-kernel@sf-tec.de> <20070604114900.GS5500@stusta.de> <200706041413.20477.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706041413.20477.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 02:13:11PM +0200, Rolf Eike Beer wrote:
> Adrian Bunk wrote:
> > On Thu, May 17, 2007 at 11:56:56PM +0200, Rolf Eike Beer wrote:
> > > Fix roundup_pow_of_two(1)
> > >
> > > 1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It
> > > does in case the argument is a variable but in case it's a constant it
> > > behaves wrong and returns 0. Probably nobody ever did it so this was
> > > never noticed.
> >
> > I'm not getting the problem.
> > 2^0 = 1
> 
> Yes. But it returned 0 (not 1 << 0).

Sorry, I had a thinko and you are right.

> Eike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

