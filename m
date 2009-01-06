Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZAFCo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZAFCo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZAFCoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:44:19 -0500
Received: from thunk.org ([69.25.196.29]:53050 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZAFCoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:44:19 -0500
Date: Mon, 5 Jan 2009 21:44:15 -0500
From: Theodore Tso <tytso@mit.edu>
To: Ken Witherow <ken@krwtech.com>
Cc: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Half-Disaster switching from ext3 to ext4
Message-ID: <20090106024415.GG14500@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ken Witherow <ken@krwtech.com>,
	Giangiacomo Mariotti <gg.mariotti@gmail.com>,
	linux-kernel@vger.kernel.org
References: <12bfabe40901031923r3a828f71v74a8c6a56746b2ec@mail.gmail.com> <20090106004706.GF14500@mit.edu> <Pine.LNX.4.64.0901052023260.11020@death.krwtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901052023260.11020@death.krwtech.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 09:11:27PM -0500, Ken Witherow wrote:
>
> I had something similar happen last week on an image I mount via a loop  
> device (it's an image I use just for my gentoo portage directory so it  
> doesn't thrash the rest of my filesystem).

> Jan  1 22:30:21 death EXT4-fs error (device loop0): mb_free_blocks: double-free of inode 0's block 58359(bit 25591 in group 1)
> Jan  1 22:30:21 death 

Actually, that's a different problem.   It's fixed in the patch:

ext4: Fix race between read_block_bitmap() and mark_diskspace_used()

in the ext4 patch queue (filename:
fix-race-between-read_block_bitmap-and-mark_diskspace_used) and in the
2.6.28-ext4-1 patch set.  I'm about to push it to Linus, and I'll make
sure it's queued for the 2.6.28.1 stable truee.


							- Ted
