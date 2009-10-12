Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZJLXjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZJLXjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbZJLXjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:39:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315AbZJLXjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:39:20 -0400
Date: Mon, 12 Oct 2009 16:26:07 -0700
From: Greg KH <gregkh@suse.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Moving drivers into staging (was Re: [GIT PULL] SCSI fixes for
 2.6.32-rc3)
Message-ID: <20091012232607.GB24254@suse.de>
References: <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
 <20091008210737.GD29181@mit.edu>
 <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
 <20091009091538.GA4154@elte.hu>
 <1255097287.2934.21.camel@localhost.localdomain>
 <20091012130652.GB25464@elte.hu>
 <1255357148.2850.91.camel@localhost.localdomain>
 <20091012145453.GD4565@elte.hu>
 <20091012150911.GB1656@suse.de>
 <1255362186.2850.348.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255362186.2850.348.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:43:06AM -0500, James Bottomley wrote:
> If you want to make this a mandatory path for old drivers, then, I think
> it's far too rigid, yes.   There's a huge amount of danger to changing
> working drivers simply on grounds of code cleanup and that danger
> increases exponentially as they get older and the hardware gets rarer.
> Look at what happened to the initio driver in 2008 for instance.  That
> was cleaned up by Alan Cox, no mean expert in the field, with the
> assistance of a tester with the actual card, so basically a textbook
> operation.  However, a bug crept in during this process that wasn't
> spotted by the tester.  When it was spotted (bug report ~6 months later)
> the original tester wasn't available and code inspection across the
> cleanup was very hard.  Fortunately, the reporter was motivated to track
> down and patch the driver, so it worked out all right in the end, but a
> lot of bug reporters aren't so capable (or so motivated).  Plus most
> clean up patches for old hardware tend only to be compile tested, so the
> potential for bugs is far greater.

I understand the potential for bugs, and am not saying to do this for
all drivers, so it is not mandatory at all.

I have just received a bunch of people asking me if we can use
drivers/staging/ to get stuff that is known broken, or has other
problems (style issues[1]), out into an area where people know it needs
to be fixed up otherwise it will be dropped.

thanks,

greg k-h

[1] No, floppy.c doesn't count, no matter how much people might want it
    to :)
