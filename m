Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZJAGkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZJAGkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZJAGky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:40:54 -0400
Received: from thunk.org ([69.25.196.29]:54655 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZJAGky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:40:54 -0400
Date: Thu, 1 Oct 2009 02:40:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Kernel BUG] ext4 for v2.6.32 round II
Message-ID: <20091001064041.GV24383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Msrgx-0001br-MP@closure.thunk.org> <20091001014128.GA2092@phenom2.trippelsdorf.de> <alpine.LFD.2.01.0909301847030.6996@localhost.localdomain> <20091001021531.GA2025@phenom2.trippelsdorf.de> <20091001030151.GR24383@mit.edu> <20091001034716.GA2008@phenom2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001034716.GA2008@phenom2.trippelsdorf.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 05:47:16AM +0200, Markus Trippelsdorf wrote:
> On Wed, Sep 30, 2009 at 11:01:51PM -0400, Theodore Tso wrote:
> > Hi Markus, 
> > 
> > I'm pretty sure the following should fix your problems; can you
> > confirm?
> 
> Yes, everything is fine again.

Linus, can you pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This will pick up the fix to the problem Markus reported, plus some
old code that we had promised would be removed for 2.6.31.

    	      	     	      	       	       - Ted

Eric Sandeen (1):
      ext4: drop ext4dev compat

Theodore Ts'o (1):
      ext4: fix a BUG_ON crash by checking that page has buffers attached to it

 fs/ext4/Kconfig |   14 --------------
 fs/ext4/inode.c |   22 +++++++++++-----------
 fs/ext4/super.c |   31 -------------------------------
 3 files changed, 11 insertions(+), 56 deletions(-)
