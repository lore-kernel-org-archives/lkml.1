Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXIRQKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXIRQKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbXIRQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:10:30 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:51104 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757136AbXIRQK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:10:29 -0400
Date: Tue, 18 Sep 2007 19:09:49 +0300
From: Ville Herva <v@iki.fi>
To: Jan Kara <jack@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070918160949.GR29062@vianova.fi>
Reply-To: v@iki.fi
References: <20070918122314.GL29062@vianova.fi> <20070918151206.GC13304@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918151206.GC13304@atrey.karlin.mff.cuni.cz>
X-Operating-System: Linux herkules.vianova.fi 2.4.35
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 05:12:06PM +0200, you [Jan Kara] wrote:
>   Hello,
> 
> > I got a bunch of these into dmesg:
> > 
> > EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323880: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> > EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> > EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323882: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
> > 
> > The kernel is 2.4.35 SMP, dual-processor. The scsi driver is Fusion MPT SCSI
> > Host driver 2.05.16.
> > 
> > The device is /dev/sda2, root fs.
> > 
> > One line per each directory had dropped into dmesg each night (I think
> > during updatedb) before I noticed.
>   Interesting. Can you look (using debugfs) on the content of the
> /usr/share/doc/ directory? It seems like parts of it have been zeroed
> out...

Unfortunately, no. I removed those directories because those were the only
ones causing problems and wasn't able to reboot for a proper fsck
immediately. The rm -rf command gave no errors (to stdout or dmesg), and a
read-only fsck right after that gave no errors on the directory structure.

Sorry for the sparse details, but when you have these kind of problems on
live servers, you tend to forget the debuggability...



-- v -- 

v@iki.fi

