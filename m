Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYIQPwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYIQPwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYIQPvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:51:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:33545 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYIQPvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:51:54 -0400
Date: Thu, 18 Sep 2008 00:51:06 +0900 (JST)
Message-Id: <20080918.005106.88393015.ryusuke@osrg.net>
To: joern@logfs.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sato.koji@lab.ntt.co.jp
Subject: Re: [PATCH 02/27] nilfs2: disk format and userland interface
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20080917143103.GC8750@logfs.org>
References: <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1221419304-18572-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20080917143103.GC8750@logfs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 16:31:03 +0200, Jörn Engel wrote:
> On Mon, 15 September 2008 04:07:59 +0900, Ryusuke Konishi wrote:
> >
> > +struct nilfs_inode {
> > +	__le64	i_blocks;
> > +	__le64	i_size;
> > +	__le64	i_ctime;
> > +	__le64	i_mtime;
> > +	__le64	i_dtime;
> > +	__le32	i_uid;
> > +	__le32	i_gid;
> > +	__le16	i_mode;
> > +	__le16	i_links_count;
> > +	__le32	i_flags;
> > +	__le64	i_bmap[NILFS_INODE_BMAP_SIZE];
> > +#define i_device_code	i_bmap[0]
> > +	__le64	i_xattr;
> > +	__le32	i_generation;
> > +	__le32	i_pad;
> > +};
> 
> No atime.  Seems familiar. :)
> 
> Did you test the filesystem on big endian systems?  It is relatively
> easy to miss bugs if conversion isn't actually necessary.
> 
> Jörn

Yes, we did.  We have test machines for this end.  We had actually
conversion misses and alignment errors in the early days.
And know big endian system is a requisite for us :)

Regards,
Ryusuke
