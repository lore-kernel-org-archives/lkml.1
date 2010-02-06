Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0BFIte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:49:34 -0500
Received: from kroah.org ([198.145.64.141]:49275 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab0BFItd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:49:33 -0500
Date: Sat, 6 Feb 2010 00:49:36 -0800
From: Greg KH <greg@kroah.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ben Hutchings <ben@decadent.org.uk>, stable-review@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
Message-ID: <20100206084936.GA4441@kroah.com>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de> <20100204185752.GA18595@kroah.com> <87iqacdcfj.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqacdcfj.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 08:32:32PM +0100, Sven Joachim wrote:
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

I think this was the sysctl issue, and have released a 2.6.32.8-rc2.
Can you test that to verify if it fixes your crash or not?

thanks,

greg k-h
