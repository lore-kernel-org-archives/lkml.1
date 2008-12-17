Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759132AbYLQL3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYLQL3Q (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYLQL26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:28:58 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:56978 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYLQL26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:28:58 -0500
Date: Wed, 17 Dec 2008 12:30:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Message-ID: <20081217113029.GB5027@uranus.ravnborg.org>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain> <20081216181133.2342b49e@lxorguk.ukuu.org.uk> <20081216183817.GA25108@uranus.ravnborg.org> <20081217100727.5cf6248c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217100727.5cf6248c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:07:27AM +0000, Alan Cox wrote:
> 
> > Smells like a kbuild issue.
> > Please copy me and linux-kbuild@vger.kernel.org on any findings.
> > 
> > [My 64 bit toolchain is br0ken atm so I could not try to reproduce]
> 
> Yes I do indeed need to build x86_64 first, then make distclean or
> mrproper and then 32bit build fails

I will fix my 64 bit build soonish.
In the meantime could someone do:

1) git clean -dxf
2) Make a 64 bit x86 build.
3) make distclean
4) git ls-files -o

And post the output of 4)
Something is left that causes us to fail and I wonder what it is.

[I'm afraid it is not this simple but I hope this can tell us what it is]

	Sam
