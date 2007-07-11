Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbXGKLy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbXGKLy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXGKLys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:54:48 -0400
Received: from pat.uio.no ([129.240.10.15]:60062 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbXGKLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:54:46 -0400
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
In-Reply-To: <20070711084737.GA17675@infradead.org>
References: <1183275465.4010.130.camel@localhost.localdomain>
	 <20070711084737.GA17675@infradead.org>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 07:54:37 -0400
Message-Id: <1184154877.6462.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.125)
X-UiO-Scanned: 38E87496EDAE2CF399F9599404A6AF0466E6892D
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1115 total 2804005 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 09:47 +0100, Christoph Hellwig wrote:
> On Sun, Jul 01, 2007 at 03:37:45AM -0400, Mingming Cao wrote:
> > This patch is on top of i_version_update_vfs.
> > The i_version field of the inode is set on inode creation and incremented when
> > the inode is being modified.
> 
> Which is not what i_version is supposed to do.  It'll get you tons of misses
> for NFSv3 filehandles that rely on the generation staying the same for the
> same file.  Please add a new field for the NFSv4 sequence counter instead
> of making i_version unuseable.

Aren't you confusing i_version and i_generation here? Those are two
separate inode fields.

Cheers
  Trond

