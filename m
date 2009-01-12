Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZALMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZALMr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZALMqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:46:52 -0500
Received: from sov-mail-b0005.gradwell.net ([193.84.87.29]:41445 "EHLO
	sov-mail-b0005.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755251AbZALMqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:46:50 -0500
Date: Mon, 12 Jan 2009 12:46:36 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Fw: Online ext4 defragmention
Message-ID: <20090112124636.3d2868f4@lithium.local.net>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009 15:28:38 -0500, I waved a wand and this message
magically appears in front of Theodore Tso:

> On Sun, Jan 11, 2009 at 01:44:43PM +0000, Alex Buell wrote:
> > Can someone confirm if the online ext4 defragmentation ioctls will
> > be going into 2.6.29? Thanks, I'm planning a migration from a
> > disparate collection of filesystems to ext4 over the next few
> > months. 
> 
> Unfortunately, the defragmentation patches need to a lot of work (to
> be honest, largely refactored and almost rewritten) before they are
> ready to for mainline yes.  I am also concerned that the current
> defrag patches also try too hard to keep blocks in the same block
> group, even as a higher priority keeping them non-fragmented.

So maybe 2.6.30? :-D

> Also, note that some of the benefits of ext4 only show up if you do a
> backup, mkfs, and restore; that's because there are layout changes
> that can only take place if you reformat the filesystem.  Finally,
> there are some allocation algorithm changes which didn't make the
> 2.6.29 merge window which I think will make a long-term difference.
> So you'll probably want to use 2.6.29 with the ext4 patch set.
> 
> So if you want the best performance and fastest fsck times (which I
> infer given your query about the defragmentation ioctls), you may want
> to consider doing a reformat and restore operation as part of your
> ext4 migration, at least for filesystem that you plan to use for
> active use.  If the filesystem is just going to be an mp3 archive, for
> example, it might not be worth it to do the backup/reformat/restore
> path.

Having done 1) remounting ext3 volumes as ext4 and 2) backing up data
before reformatting as an ext4 volume, and restoring afterwards, and
noticed that with option 2 I got noticeable improvements in
performance. 

Thank you for your advice, it seems reformatting is the best thing to
do. 
-- 
http://www.munted.org.uk

Fearsome grindings.


-- 
http://www.munted.org.uk

Fearsome grindings.
