Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZLUGcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZLUGcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 01:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZLUGcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 01:32:51 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42678 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZLUGcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 01:32:51 -0500
Date: Mon, 21 Dec 2009 15:32:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Message-ID: <20091221063238.GC15721@linux-sh.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain> <200912171618.32882.bzolnier@gmail.com> <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 02:04:37PM +0100, Jiri Kosina wrote:
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> > > > I like this patch, this is actually what I wanted to do.
> > > 
> > > I have nothing against a switch, but it had better default to off.
> > > 
> > > The whole 80-char limit is insane. It results in insane "fixes". Just 
> > > about every time somebody "improves" a patch due to the warning, the 
> > > result is worse than the original patch.
> > 
> > Examples? :)
> 
> balance_leaf() in fs/reiserfs/do_balan.c
> 
> Example picked totally at random:
> 
> 	set_le_ih_k_offset(ih,
> 			   le_ih_k_offset(ih) +
> 			   (tb->
> 			    lbytes <<
> 			    (is_indirect_le_ih
> 			     (ih) ? tb->tb_sb->
> 			     s_blocksize_bits -
> 			     UNFM_P_SHIFT :
> 			     0)));
> 
> See how everything is nicely aligned to 80 cols?
> 
> 
> Generally, don't look at this function after having a good lunch you want 
> to keep. You have been warned.
> 
This isn't a valid example, as it wasn't written by a human. This is the
result of Lindent being run blindly on the file and nothing more.

Try again.
