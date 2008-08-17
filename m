Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYHQNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYHQNwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 09:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYHQNv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 09:51:59 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57232 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752700AbYHQNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 09:51:58 -0400
Date: Sun, 17 Aug 2008 09:51:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc3-git3: Reported regressions from 2.6.26
Message-ID: <20080817135134.GA8162@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 09:00:39PM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11341
> Subject		: 2.6.27-rc1 - ext4 e2fsck false prompting for fixing i_size of Inode
> Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Date		: 2008-08-13 6:56 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=121861058720051&w=4

This wasn't a regression because it wasn't a kernel bug (and so by
definition it existed on prior kernel versions :-).  I've just checked
in a fix into the e2fsprogs repository, and I've included the
e2fsprogs patch in the bugzilla record for the user's convenience.

	  	       		       	       - Ted
