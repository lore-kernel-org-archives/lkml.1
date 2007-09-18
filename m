Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbXIRQXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbXIRQXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbXIRQW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:22:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49393 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbXIRQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:22:57 -0400
Date: Tue, 18 Sep 2007 18:22:56 +0200
From: Jan Kara <jack@suse.cz>
To: Ville Herva <v@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070918162256.GA3280@atrey.karlin.mff.cuni.cz>
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz> <20070918160949.GR29062@vianova.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918160949.GR29062@vianova.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Sep 18, 2007 at 05:12:06PM +0200, you [Jan Kara] wrote:
> >   Hello,
> > 
> > > I got a bunch of these into dmesg:
> > > 
> > > EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323880: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> > > EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> > > EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323882: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> > > 
> > > The kernel is 2.4.35 SMP, dual-processor. The scsi driver is Fusion MPT SCSI
> > > Host driver 2.05.16.
> > > 
> > > The device is /dev/sda2, root fs.
> > > 
> > > One line per each directory had dropped into dmesg each night (I think
> > > during updatedb) before I noticed.
> >   Interesting. Can you look (using debugfs) on the content of the
> > /usr/share/doc/ directory? It seems like parts of it have been zeroed
> > out...
> 
> Unfortunately, no. I removed those directories because those were the only
> ones causing problems and wasn't able to reboot for a proper fsck
> immediately. The rm -rf command gave no errors (to stdout or dmesg), and a
> read-only fsck right after that gave no errors on the directory structure.
> 
> Sorry for the sparse details, but when you have these kind of problems on
> live servers, you tend to forget the debuggability...
  Yes, I can understand that :). It's just that now it's hard to find
out what has really happened. Anyway, thanks for your report.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
