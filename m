Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZLRNE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZLRNE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZLRNEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:04:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:54300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZLRNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:04:45 -0500
Date: Fri, 18 Dec 2009 14:04:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
In-Reply-To: <200912171618.32882.bzolnier@gmail.com>
Message-ID: <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain> <200912171618.32882.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:

> > > I like this patch, this is actually what I wanted to do.
> > 
> > I have nothing against a switch, but it had better default to off.
> > 
> > The whole 80-char limit is insane. It results in insane "fixes". Just 
> > about every time somebody "improves" a patch due to the warning, the 
> > result is worse than the original patch.
> 
> Examples? :)

balance_leaf() in fs/reiserfs/do_balan.c

Example picked totally at random:

	set_le_ih_k_offset(ih,
			   le_ih_k_offset(ih) +
			   (tb->
			    lbytes <<
			    (is_indirect_le_ih
			     (ih) ? tb->tb_sb->
			     s_blocksize_bits -
			     UNFM_P_SHIFT :
			     0)));

See how everything is nicely aligned to 80 cols?


Generally, don't look at this function after having a good lunch you want 
to keep. You have been warned.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

