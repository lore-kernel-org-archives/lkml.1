Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZKYL4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZKYL4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZKYL4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:56:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:36720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934121AbZKYL4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:56:47 -0500
Date: Wed, 25 Nov 2009 12:56:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: tytso@mit.edu
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: manual merge of the trivial tree with the ext4
 tree
In-Reply-To: <20091125114522.GD14289@thunk.org>
Message-ID: <alpine.LSU.2.00.0911251256190.6953@wotan.suse.de>
References: <20091125183414.eb45acca.sfr@canb.auug.org.au> <alpine.LSU.2.00.0911251216270.6953@wotan.suse.de> <20091125114522.GD14289@thunk.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, tytso@mit.edu wrote:

> > > Today's linux-next merge of the trivial tree got a conflict in
> > > fs/ext4/balloc.c between commit 4433871130f36585fde38e7dd817433296648945
> > > ("ext4: fold ext4_free_blocks() and ext4_mb_free_blocks()") from the ext4
> > > tree and commit 15dcf8433b514d1dc1b80d87a0798c2db2c37e95 ("tree-wide: fix
> > > some typos and punctuation in comments") from the trivial tree.
> > > 
> > > The former moved the comment fixed by the latter and fixed the typo along
> > > the way.
> > 
> > Dropped the mballoc hunk from my queue, thanks.
> 
> You mean balloc hunk, I hope.  (In the commit in question, I moved the
> comment from fs/ext4/balloc.c to fs/ext4/mballoc.c.)

Yup, sorry, I have been looking at completely different patch while 
writing the mail and got side-tracked.

Anyway, the conflict between ext4 and trivial trees should be gone now.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
