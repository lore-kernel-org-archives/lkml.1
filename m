Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZASXhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZASXhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZASXhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:37:38 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62134 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZASXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:37:37 -0500
Date: Tue, 20 Jan 2009 07:36:51 +0800
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/20] return f_fsid for statfs(2)
In-reply-to: <1232393334.5893.42.camel@norville.austin.ibm.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: coly.li@suse.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>,
       reiserfs-devel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-id: <20090119233651.GK3286@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <4974B8C4.3070703@suse.de>
 <1232393334.5893.42.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 19, 2009  13:28 -0600, Dave Kleikamp wrote:
> ext[234] return a portion of the uuid in f_fsid.  There is a theoretical
> chance of those values being non-unique.  Since there doesn't appear to
> be any case for the fsid to be persistent between boots, I guess
> huge_encode_dev() is probably a better choice.  In practice it probably
> makes no difference.

I'm not sure what you mean about "no case for fsid to be persistent"?
The whole point of fsid (for NFS) is that this identifies the filesystem
over reboot, even if the block device ID changes, or if the filesystem
doesn't have a block device at all (e.g. cluster filesystem).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

