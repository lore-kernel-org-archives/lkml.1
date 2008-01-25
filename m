Return-Path: <linux-kernel-owner+w=401wt.eu-S1763691AbYAYIC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763691AbYAYIC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760363AbYAYH7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47045 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763827AbYAYH67 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:58:59 -0500
Date: Fri, 25 Jan 2008 18:56:53 +1100
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve French <sfrench@us.ibm.com>, Lachlan McIlroy <lachlan@sgi.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Russell King <rmk@arm.linux.org.uk>,
       Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Karsten Keil <kkeil@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jeff Dike <jdike@addtoit.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       William Irwin <wli@holomorphy.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Jeff Mahoney <jeffm@suse.com>, Paul Mackerras <paulus@samba.org>,
       Hugh Dickins <hugh@veritas.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 01/26] mount options: add documentation
Message-ID: <20080125075653.GS155259@sgi.com>
References: <20080124193416.379218079@szeredi.hu> <200801250024.m0P0OmXX011168@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801250024.m0P0OmXX011168@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In message <20080124193416.379218079@szeredi.hu>, Miklos Szeredi writes:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > This series addresses the problem of showing mount options in
> > /proc/mounts.
[...]
> > The following filesystems still need fixing: CIFS, NFS, XFS, Unionfs,
> > Reiser4.  For CIFS, NFS and XFS I wasn't able to understand how some
> > of the options are used.  The last two are not yet in mainline, so I
> > leave fixing those to their respective maintainers out of pure
> > laziness.

XFS has already been updated. The fix is in the XFs git tree that
Andrew picks up for -mm releases and will be merged in the 2.6.25-rc1
window. Commit is here:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=8c33fb6ca99aa17373bd3d5a507ac0eaefb7abb4

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
