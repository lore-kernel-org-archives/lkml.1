Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYCZVIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYCZVIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYCZVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:07:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39358 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbYCZVH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:07:56 -0400
Date: Wed, 26 Mar 2008 22:08:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip OTP memory
Message-ID: <20080326210819.GC24954@uranus.ravnborg.org>
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org> <47EA268F.8070006@gmail.com> <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com> <47EA971B.1020502@gmail.com> <8bd0f97a0803261140w7498b0cfwff38302779f589dc@mail.gmail.com> <20080326190917.GB24954@uranus.ravnborg.org> <8bd0f97a0803261214y3db259edxbb22b8655a5c6693@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0803261214y3db259edxbb22b8655a5c6693@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 03:14:14PM -0400, Mike Frysinger wrote:
> On Wed, Mar 26, 2008 at 3:09 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >  > >  > also, it isnt "broken" in the sense that it "doesnt work" ;)
> >  > >
> >  > >  Gcc simply doesn't allow that, you likely got 2 sections with init.data, with
> >  > >  and without readonly bit set, which is wrong, and it seems, that on some systems
> >  > >  (debian) you won't even compile it.
> >  >
> >  > gcc-4.1.2/binutils-2.17 doesnt have a problem compiling/linking the
> >  > code in question.  and i imagine i would have noticed a build/link
> >  > failure long before testing it on actual hardware.
> >
> >  target arch dependent. Try with 64 bit powerpc.
> 
> this code appears in drivers that are for Blackfin-specific pieces of
> hardware.  it may fail to build on
> some-random-arch-that-isnt-Blackfin, but if it works for Blackfin,
> what do the other arches realistically matter ?
> 
> yes, the code will get changed as suggested as it is the right thing
> to do, it just isnt a real problem today.
It is a real problem for build monkeys (like me sometimes) if
an allyesconfig suddenly does not build.

If this driver can be build for other than blackfin I do not
know.

	Sam
