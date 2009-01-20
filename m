Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZATEpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZATEpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 23:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZATEpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 23:45:06 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:32915 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZATEpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 23:45:03 -0500
Date: Mon, 19 Jan 2009 21:44:47 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
In-reply-to: <49755376.3000100@suse.de>
To: Coly Li <coly.li@suse.de>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>,
       reiserfs-devel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-id: <20090120044447.GM3286@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <4974B8C4.3070703@suse.de>
 <1232393334.5893.42.camel@norville.austin.ibm.com>
 <20090119233651.GK3286@webber.adilger.int>
 <1232419149.19468.3.camel@norville.austin.ibm.com>
 <20090120041349.GL3286@webber.adilger.int> <49755376.3000100@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2009  12:30 +0800, Coly Li wrote:
> Ext[234] is sophisticated to have on-disk uuid record. Most file systems
> in the patches (except jfs and reiser3) do not have a persistent uuid,
> a reasonable/feasible solution without media format modification is fsid
> in boot/mount life cycle. That's why huge_encode_dev(sb->s_bdev->bd_dev)
> is used here.  For jfs and reiserfs3, is there any use case for
> persistent fsid cross boots ?

I would say yes, this is worthwhile to do, or the fsid can change between
boots unnecessarily.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

