Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYJZCj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYJZCj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 22:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYJZCjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 22:39:20 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41569 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704AbYJZCjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 22:39:19 -0400
Date: Sat, 25 Oct 2008 22:39:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org
Subject: [GIT PULL] Re: [PATCH] Re: ext3: fix ext3_dx_readdir hash
	collision handling - Regression
Message-ID: <20081026023914.GA10603@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	akpm@linux-foundation.org
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de> <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org> <20081025115631.GA17661@mit.edu> <alpine.LFD.2.00.0810251414400.3327@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810251414400.3327@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 02:15:41PM -0700, Linus Torvalds wrote:
> Your patch seems to fix it for me, so ack on that. Please do send a 
> version with a sign-off when you're ok with it - otherwise I'll have to 
> revert the old one..

OK, please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

I did some more testing, and I think I screwed up my tests on the
32-bit kernel (or I was testing "rm -rf", not "rm -r").  These patches
are identical to what I sent before, but with patch comments and a
sign-off.

							- Ted

Theodore Ts'o (2):
      ext3: Fix duplicate entries returned from getdents() system call
      ext4: Fix duplicate entries returned from getdents() system call

 fs/ext3/dir.c |   20 ++++++++------------
 fs/ext4/dir.c |   20 ++++++++------------
 2 files changed, 16 insertions(+), 24 deletions(-)

