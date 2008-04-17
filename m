Return-Path: <linux-kernel-owner+w=401wt.eu-S933752AbYDQBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbYDQBeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbYDQBRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:17:34 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:55468 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbYDQBRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:17:31 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2008 21:17:31 EDT
Date: Thu, 17 Apr 2008 04:08:35 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Jamie Lokier <jamie@shareable.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <20080415152313.GB8513@shareable.org>
Message-ID: <Pine.LNX.4.61.0804170357290.4657@dhcppc2>
References: <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
 <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu>
 <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu>
 <20080414115540.GA5802@shareable.org> <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu>
 <20080414223556.GA21340@shareable.org> <E1JljQD-0008Ae-5H@pomaz-ex.szeredi.hu>
 <20080415152313.GB8513@shareable.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Apr 2008, Jamie Lokier wrote:
> Miklos Szeredi wrote:
> > > > How old?  The out of tree fuse module (hoping to get rid of it soon)
> > > > works down to 2.6.9.  Beyond that it does probably require a fair
> > > > amount of porting work.
> > > 
> > > I imagine that backporting FUSE to 2.4 no-mmu will be more work than
> > > backporting a filesystem, but I could be mistaken.  Moving my project
> > > to a 2.6 kernel (*any* 2.6 kernel) would be much more work than
> > > either.
> > 
> > Fuse-2.5 still supported linux-2.4.  Although I have no idea if it
> > works with no-mmu, maybe it's worth a try.
> > 
> > Backporting ntfs-3g to an older version of fuse shouldn't be a big
> > problem, as the fuse interface didn't change very much since then.
> 
> Thanks for your advice.  I will look into all these possibilities.
> Fuse working would be quite useful in many other ways too.

ntfs-3g was reported to work on 2.4 no-mmu kernels six months ago (though 
it had no our QA). Please see http://ntfs-3g.org/support.html#kernel24 and 
search for nommu on fuse-devel for the details.

	Szaka
