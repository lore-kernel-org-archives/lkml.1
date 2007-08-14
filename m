Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXHNTeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXHNTeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934804AbXHNTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:33:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46144 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367AbXHNTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:33:46 -0400
Date: Tue, 14 Aug 2007 20:33:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Rene Herman <rene.herman@gmail.com>,
       git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Message-ID: <20070814193333.GI21089@ftp.linux.org.uk>
References: <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu> <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost> <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 11:40:09AM -0700, Linus Torvalds wrote:

> A much *better* picture than some manually maintained thing, in fact, 
> because it tells you who really does the work, and which way patches go...
> 
> (Maybe you want to add a
> 
> 	grep -v '\(Linus Torvalds\)\|\(Andrew Morton\)'
> 
> to avoid seeing the normal chain too much, but hey, we probably want to 
> know too. Anyway - the script can certainly be tweaked, the point is 
> really just that the git tree _already_ contains the relevant 
> information).

FWIW, I suspect that we are looking at that from the wrong POV.  If
that's about "who ought to be Cc'd on the issues dealing with <list
of pathnames>", why does it have to be tied to "who is maintainer for
<pathname>"?

I'm not suggesting something like fs.ext2@kernel.org with something
like majordomo allowing to add yourself to those, but something less
extreme in that direction might be worth thinking about...  Hell,
even simple
$ finger fs/minix/dir.c@cc.kernel.org
with majordomo-like interface for adding yourself to such lists
might solve most of those problems...
