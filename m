Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYHVHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYHVHK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYHVHKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:10:12 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61796 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYHVHKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:10:11 -0400
Date: Fri, 22 Aug 2008 01:09:58 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
In-reply-to: <20080821125841.a04a706f.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-fsdevel@vger.kernel.org,
       dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
       axboe@kernel.dk, mtk.manpages@googlemail.com,
       linux-kernel@vger.kernel.org
Message-id: <20080822070958.GU3392@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080818212819t-sato@mail.jp.nec.com>
 <20080821125841.a04a706f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 21, 2008  12:58 -0700, Andrew Morton wrote:
> >  #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
> > +#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
> > +#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
> 
> FIFREEZE is 119, but a few lines above we have
> 
> #define BLKDISCARD _IO(0x12,119)
>
> Should we be using 120 and 121 here?

No, because 'X' != 0x12...  The 'X' is used because this ioctl is compatible
with the XFS implementation of this feature.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

