Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbZAFArU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbZAFArU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZAFArL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:47:11 -0500
Received: from thunk.org ([69.25.196.29]:37788 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZAFArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:47:10 -0500
Date: Mon, 5 Jan 2009 19:47:06 -0500
From: Theodore Tso <tytso@mit.edu>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Half-Disaster switching from ext3 to ext4
Message-ID: <20090106004706.GF14500@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Giangiacomo Mariotti <gg.mariotti@gmail.com>,
	linux-kernel@vger.kernel.org
References: <12bfabe40901031923r3a828f71v74a8c6a56746b2ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12bfabe40901031923r3a828f71v74a8c6a56746b2ec@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 04:23:42AM +0100, Giangiacomo Mariotti wrote:
> the partitions(except for root obviously), I synced some times before
> doing that and then I shut down the pc with a "shutdown -h -P now".
> when I booted again the system, /dev/sda2(the partition with the most
> important data. Murphy's law really works!) failed to get mounted with
> a message saying something about corrupted groups(maybe, I don't
> remember exactly). Trying to do a fsck.ext4 -p /dev/sda2, I got
> something like : fsck.ext4 : Invalid argument while checking ext3
> journal for /dev/sda2. 

What version of e2fsprogs do you have installed, and can you dig up
the exact error message at mount time?  It should be in the your
system logs....

> remounted it, all files were gone! I was starting to use the sleuth
> kit, when I noticed that in the search+found directory there were
> almost all the files, but not all of them and in a rearrenged
> directory structure.

Sounds like the root inode got zapped.  As for why, it's hard to say.
It could be a simple disk failure that happend as bad luck.  I haven't
seen any other bug reports that report corruption similar to yours, so
without a lot more information or a way to reproduce the error,
there's not much more I can say.

Regards,

						- Ted
