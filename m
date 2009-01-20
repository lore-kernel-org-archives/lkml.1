Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZATCj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZATCj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZATCjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:39:15 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34234 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZATCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:39:13 -0500
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Cc: coly.li@suse.de, linux-kernel@vger.kernel.org,
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
In-Reply-To: <20090119233651.GK3286@webber.adilger.int>
References: <4974B8C4.3070703@suse.de>
	 <1232393334.5893.42.camel@norville.austin.ibm.com>
	 <20090119233651.GK3286@webber.adilger.int>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 20:39:09 -0600
Message-Id: <1232419149.19468.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 07:36 +0800, Andreas Dilger wrote:
> On Jan 19, 2009  13:28 -0600, Dave Kleikamp wrote:
> > ext[234] return a portion of the uuid in f_fsid.  There is a theoretical
> > chance of those values being non-unique.  Since there doesn't appear to
> > be any case for the fsid to be persistent between boots, I guess
> > huge_encode_dev() is probably a better choice.  In practice it probably
> > makes no difference.
> 
> I'm not sure what you mean about "no case for fsid to be persistent"?
> The whole point of fsid (for NFS) is that this identifies the filesystem
> over reboot, even if the block device ID changes, or if the filesystem
> doesn't have a block device at all (e.g. cluster filesystem).

I guess that just demonstrates how little I know about what the fsid is
about.  Would it be preferable for file systems that have a uuid to use
that instead?  Of course anything is an improvement over zeroes.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

