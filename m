Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0BFJz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:55:26 -0500
Received: from kroah.org ([198.145.64.141]:48522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab0BFJzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:55:24 -0500
Date: Sat, 6 Feb 2010 01:55:15 -0800
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Sven Joachim <svenjoac@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable-review@kernel.org
Subject: Re: [stable] [Stable-review] [PATCH] Fix
	'flush_old_exec()/setup_new_exec()' split
Message-ID: <20100206095515.GA6996@kroah.com>
References: <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de> <20100204185752.GA18595@kroah.com> <87iqacdcfj.fsf@turtle.gmx.de> <20100206084936.GA4441@kroah.com> <87mxzm1zyr.fsf@turtle.gmx.de> <20100206093144.GE23328@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100206093144.GE23328@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 10:31:44AM +0100, Willy Tarreau wrote:
> On Sat, Feb 06, 2010 at 10:21:48AM +0100, Sven Joachim wrote:
> > On 2010-02-06 09:49 +0100, Greg KH wrote:
> > 
> > > I think this was the sysctl issue, and have released a 2.6.32.8-rc2.
> > > Can you test that to verify if it fixes your crash or not?
> > 
> > Yes, it fixes the issue.  I'm using -rc2 right now, did not notice any
> > problems so far.
> 
> FWIW, it's running fine here too. I've tried to boot on a miniature
> init launcher I have (statically linked one) and did not have any issue.

Wonderful, thanks to both of you for letting me know.  I feel a lot
better about this release now...

thanks,

greg k-h
