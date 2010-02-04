Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0BDTjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:39:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363Ab0BDTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:39:16 -0500
Date: Thu, 4 Feb 2010 11:37:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sven Joachim <svenjoac@gmx.de>
cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
       stable-review@kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
In-Reply-To: <87iqacdcfj.fsf@turtle.gmx.de>
Message-ID: <alpine.LFD.2.00.1002041135110.3707@localhost.localdomain>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de>
 <20100204185752.GA18595@kroah.com> <87iqacdcfj.fsf@turtle.gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Sven Joachim wrote:

> On 2010-02-04 19:57 +0100, Greg KH wrote:
> 
> > On Thu, Feb 04, 2010 at 07:46:30PM +0100, Sven Joachim wrote:
> >> It seems they are all there, but on my system with 64-bit kernel and
> >> 32-bit userland, 2.6.32.8-rc1 still panics in the way noticed by Ben.
> >
> > Does 2.6.33-rc6 also cause you the same problem?
> 
> A build from Linus' current git tree (commit 7ab02af42 was added after
> 2.6.33-rc6, so I skipped that version) does not show the problem.
> Actually, I'm using it right now.

Ok, then that's just really odd. I don't think there are any other changes 
in this area, and the whole init problem sure as hell smells like execve 
setup problems. And afaik, 2.6.32.8-rc1 should have all the commits from 
current -git.

Maybe we're looking at a separate issue after all.

			Linus
