Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYAZTLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYAZTLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 14:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYAZTLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 14:11:03 -0500
Received: from verein.lst.de ([213.95.11.210]:45564 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYAZTLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 14:11:00 -0500
Date: Sat, 26 Jan 2008 20:10:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] ext3 freeze feature
Message-ID: <20080126191041.GA5233@lst.de>
References: <20080125195938t-sato@mail.jp.nec.com> <84144f020801250317pbdafc4fnd47cc8a297194e86@mail.gmail.com> <001c01c85f4f$bfd128f0$41a8400a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001c01c85f4f$bfd128f0$41a8400a@bsd.tnes.nec.co.jp>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 09:42:30PM +0900, Takashi Sato wrote:
> Hi,
> 
> >I am also wondering whether we should have system call(s) for these:
> >
> >On Jan 25, 2008 12:59 PM, Takashi Sato <t-sato@yk.jp.nec.com> wrote:
> >>+       case EXT3_IOC_FREEZE: {
> >
> >>+       case EXT3_IOC_THAW: {
> >
> >And just convert XFS to use them too?
> 
> I think it is reasonable to implement it as the generic system call, as you 
> said.
> Does XFS folks think so?

Given that XFS has implemented the ioctls for such a long time it might
make more sense to simply move the ioctl implementation to fs/ioctl.c
so it applies to all filesystem.  No need to add a new syscall when the
equivalent-functionality ioctls have to be supported forever anyway.
