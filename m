Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZAVTbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZAVTbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZAVTbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:31:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:37745 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbZAVTbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:31:01 -0500
Message-ID: <4978CAD4.9090607@suse.de>
Date: Fri, 23 Jan 2009 03:36:52 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
Cc: Andreas Dilger <adilger@sun.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
References: <4974B8C4.3070703@suse.de> <1232393334.5893.42.camel@norville.austin.ibm.com> <20090119233651.GK3286@webber.adilger.int> <1232419149.19468.3.camel@norville.austin.ibm.com> <20090120041349.GL3286@webber.adilger.int> <49755376.3000100@suse.de> <20090120044447.GM3286@webber.adilger.int> <20090120184822.GF27464@shareable.org>
In-Reply-To: <20090120184822.GF27464@shareable.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jamie Lokier Wrote:
> Andreas Dilger wrote:
>> On Jan 20, 2009  12:30 +0800, Coly Li wrote:
>>> Ext[234] is sophisticated to have on-disk uuid record. Most file systems
>>> in the patches (except jfs and reiser3) do not have a persistent uuid,
>>> a reasonable/feasible solution without media format modification is fsid
>>> in boot/mount life cycle. That's why huge_encode_dev(sb->s_bdev->bd_dev)
>>> is used here.  For jfs and reiserfs3, is there any use case for
>>> persistent fsid cross boots ?
>> I would say yes, this is worthwhile to do, or the fsid can change between
>> boots unnecessarily.
> 
> Even FAT has a volume id which should probably be used.
> I'm guessing NTFS does too.
> 
vfat volume id is assigned manually in mkfs.vfat, vfat volumes in one machine can be assigned to
same volume id value, even worse the volume id can be modified when volume is mounted. Therefore,
IMHO it's not suitable to be used as a fsid.

-- 
Coly Li
SuSE Labs
