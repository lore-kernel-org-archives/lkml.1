Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab0CKS1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:27:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab0CKS0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:26:50 -0500
Date: Thu, 11 Mar 2010 13:26:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Theodore Tso <tytso@mit.edu>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100311182638.GA28074@infradead.org>
References: <4B947393.2050002@kernel.org> <201003111927.24829.knikanth@suse.de> <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu> <201003112030.44605.knikanth@suse.de> <170fa0d21003110801p3ce6c5e9xe77b6f9f833fe19d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d21003110801p3ce6c5e9xe77b6f9f833fe19d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:01:41AM -0500, Mike Snitzer wrote:
> mkp in particular, Jens, James, myself, and others implemented and
> refined the SCSI and block changes.  kzak, jim meyering, hans de
> goede, hch, eric sandeen, bob peterson, myself and others updated all
> other I/O stack layers ranging from DM to LVM, libblkid, fdisk, parted
> to anaconda to mkfs.ext[234], mkfs.xfs, mkfs.gfs2 to virt-io and qemu.
>  FYI, all of these advances will be in Fedora 13 (quite a few are
> already in Fedora 12).

I also have some older patches for btrfs that I need to get back out
to the list.  There was some talk of major changes to the organization
of the tools so I held it back for a while longer.

