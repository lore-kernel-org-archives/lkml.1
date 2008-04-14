Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbYDNWgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbYDNWgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYDNWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:36:36 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50853 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYDNWgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:36:35 -0400
Date: Mon, 14 Apr 2008 23:35:56 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dwmw2@infradead.org, hch@infradead.org, akpm@linux-foundation.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414223556.GA21340@shareable.org>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org,
	hch@infradead.org, akpm@linux-foundation.org, me@bobcopeland.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org> <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> > > > Yes, that's quite annoying as FUSE doesn't work with my architecture,
> > > > so I can't use the only good NTFS driver.... grr! :-)
> > > 
> > > I'm not quite getting this joke :)
> > 
> > It's not really a joke.  It really is a problem: I'm supposed to
> > provide NTFS support for a project, but the kernel I'm using doesn't
> > work with FUSE (too old for the FUSE version needed by ntfs-3g),
> 
> How old?  The out of tree fuse module (hoping to get rid of it soon)
> works down to 2.6.9.  Beyond that it does probably require a fair
> amount of porting work.

I imagine that backporting FUSE to 2.4 no-mmu will be more work than
backporting a filesystem, but I could be mistaken.  Moving my project
to a 2.6 kernel (*any* 2.6 kernel) would be much more work than
either.

All other filesystems I care about are in-kernel - NTFS is quite
exceptional in needing FUSE just to get ordinary, stable file access.
(The in-kernel NTFS is regarded as unstable and missing essential
basic features.)

None of this should be taken as any kind of criticism.  I love what
you guys have done.

-- Jamie

