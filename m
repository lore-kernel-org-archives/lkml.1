Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZAAJvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZAAJvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 04:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZAAJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 04:50:59 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:36472 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbZAAJu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 04:50:58 -0500
Date: Thu, 1 Jan 2009 10:50:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
In-Reply-To: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0901011048090.14380@anakin>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Lachlan McIlroy wrote:
> The following changes since commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179:
>   Linus Torvalds (1):
>         Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com/oss/git/xfs/xfs.git for-linus

> Christoph Hellwig (91):
>       [XFS] refactor xfs_btree_readahead

On m68k, with CONFIG_LBD=n:

| fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
| fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
| fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type

left/right = xfs_fsblock_t (32 or 64 bit), NULLDFSBNO = xfs_dfsbno_t (64 bit)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
