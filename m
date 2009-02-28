Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZB1VAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZB1VAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZB1VAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:00:24 -0500
Received: from thunk.org ([69.25.196.29]:41859 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZB1VAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:00:23 -0500
Date: Sat, 28 Feb 2009 16:00:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [tytso@MIT.EDU: Re: [GIT PULL] ext4 fixes]
Message-ID: <20090228210017.GD6935@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,


Sorry, I didn't realize Eric had trimmed the cc list.  I'm forwarding
to you the updated pull request.  It appears you haven't pulled it
yet; if you have, please re-pull and make sure you got all three of
the new commit.

Thanks,

						- Ted

--fUYQa+Pmc3FrFX/N
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <tytso@MIT.EDU>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Sat, 28 Feb 2009 12:55:38 -0500
X-Sieve: CMU Sieve 2.2
Received: from fort-point-station.mit.edu by po14.mit.edu (8.13.6/4.7) id n1SHtb6A021652; Sat, 28 Feb 2009 12:55:37 -0500 (EST)
Received: from mit.edu (W92-130-BARRACUDA-3.MIT.EDU [18.7.21.224])
	by fort-point-station.mit.edu (8.13.6/8.9.2) with ESMTP id n1SHtW1W010188
	for <tytso@mit.edu>; Sat, 28 Feb 2009 12:55:32 -0500 (EST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mit.edu (Spam Firewall) with ESMTP id CE75A1365A5B
	for <tytso@mit.edu>; Sat, 28 Feb 2009 12:55:31 -0500 (EST)
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1LdTPN-00010m-7z; Sat, 28 Feb 2009 12:55:29 -0500
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1LdTPM-0004Vh-A1; Sat, 28 Feb 2009 12:55:28 -0500
Date: Sat, 28 Feb 2009 12:55:28 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes
Message-ID: <20090228175528.GC6935@mit.edu>
References: <E1LdQQ5-0004kd-OD@closure.thunk.org> <49A95B1C.9060008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A95B1C.9060008@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Scanned-By: MIMEDefang 2.42

On Sat, Feb 28, 2009 at 09:41:16AM -0600, Eric Sandeen wrote:
> 
> Ted, might be good to get my nojournal fix in too?  It's an easy oopser.
> 

Good point.  Linus, I've added Eric's nojournal to the for_linus
branch.   Here's the updated pull request:

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks!!

						- Ted

Eric Sandeen (1):
      ext4: don't call jbd2_journal_force_commit_nested without journal

Theodore Ts'o (2):
      ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
      ext4: Reorder fs/Makefile so that ext2 root fs's are mounted using ext2

 fs/Makefile      |    6 ++++--
 fs/ext4/balloc.c |    4 +++-
 fs/ext4/inode.c  |    2 +-
 fs/ext4/super.c  |    1 -
 4 files changed, 8 insertions(+), 5 deletions(-)

--fUYQa+Pmc3FrFX/N--
