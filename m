Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbZBECAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbZBECAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZBECAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:00:18 -0500
Received: from thunk.org ([69.25.196.29]:44380 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZBECAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:00:16 -0500
Date: Wed, 4 Feb 2009 21:00:13 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arthur Jones <ajones@riverbed.com>, C Sights <csights@fastmail.fm>,
       Eric Sandeen <sandeen@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #12224] journal activity on inactive partition causes
	inactive harddrive spinup
Message-ID: <20090205020013.GG8945@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arthur Jones <ajones@riverbed.com>, C Sights <csights@fastmail.fm>,
	Eric Sandeen <sandeen@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.haD.S6YiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CGyEB0S4BpO.A.haD.S6YiJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:58:33AM +0100, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
> Subject		: journal activity on inactive partition causes inactive harddrive spinup
> Submitter	: C Sights <csights@fastmail.fm>
> Date		: 2008-12-14 11:39 (53 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
> Handled-By	: Eric Sandeen <sandeen@redhat.com>

Patches against ext3 have been posted by Jan Kara and have been sucked
into the mm tree.  I don't know if Andrew is planning on waiting until
the next merge window, or is planning on pushing it sooner given that
it is a regression.  (These supercede the ones currently posted by
Eric in the BZ entry.)

Similar patches have been posted against ext4, and I will be handling
them in the ext4 tree.

						- Ted
