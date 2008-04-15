Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbYDOLea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbYDOLea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYDOLeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:34:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48187 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbYDOLeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:34:18 -0400
To: jamie@shareable.org
CC: dwmw2@infradead.org, hch@infradead.org, akpm@linux-foundation.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080414223556.GA21340@shareable.org> (message from Jamie Lokier
	on Mon, 14 Apr 2008 23:35:56 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org> <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu> <20080414223556.GA21340@shareable.org>
Message-Id: <E1JljQD-0008Ae-5H@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Apr 2008 13:33:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > Yes, that's quite annoying as FUSE doesn't work with my architecture,
> > > > > so I can't use the only good NTFS driver.... grr! :-)
> > > > 
> > > > I'm not quite getting this joke :)
> > > 
> > > It's not really a joke.  It really is a problem: I'm supposed to
> > > provide NTFS support for a project, but the kernel I'm using doesn't
> > > work with FUSE (too old for the FUSE version needed by ntfs-3g),
> > 
> > How old?  The out of tree fuse module (hoping to get rid of it soon)
> > works down to 2.6.9.  Beyond that it does probably require a fair
> > amount of porting work.
> 
> I imagine that backporting FUSE to 2.4 no-mmu will be more work than
> backporting a filesystem, but I could be mistaken.  Moving my project
> to a 2.6 kernel (*any* 2.6 kernel) would be much more work than
> either.

Fuse-2.5 still supported linux-2.4.  Although I have no idea if it
works with no-mmu, maybe it's worth a try.

Backporting ntfs-3g to an older version of fuse shouldn't be a big
problem, as the fuse interface didn't change very much since then.

Miklos
