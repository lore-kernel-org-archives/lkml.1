Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934Ab0AQQS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0AQQS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AQQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:18:58 -0500
Received: from kroah.org ([198.145.64.141]:46479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0AQQS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:18:56 -0500
Date: Sun, 17 Jan 2010 08:18:53 -0800
From: Greg KH <greg@kroah.com>
To: Ozan ??a??layan <ozan@pardus.org.tr>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable-review@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [0/9] 2.6.31.12-stable review
Message-ID: <20100117161853.GA31781@kroah.com>
References: <20100114224848.GA532@kroah.com> <4B520D98.7030202@pardus.org.tr> <20100117032319.GA27413@kroah.com> <4B5335CA.7080309@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5335CA.7080309@pardus.org.tr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 06:07:38PM +0200, Ozan ??a??layan wrote:
> Greg KH wrote:
> > On Sat, Jan 16, 2010 at 09:03:52PM +0200, Ozan ??a??layan wrote:
> >> Greg KH wrote:
> 
> > 
> > As this is going to be the last .31 release, and all users should really
> > be moving to .32, I'm not going to worry about this one.  Is that ok
> > with you?
> > 
> > thanks,
> 
> Personally I really don't like the idea of "all users should really be
> moving to .3x" which is true for individual bleeding edge users which
> compiles and uses their own kernel but there are still distributions
> around (as well as the one that I'm trying to maintain the kernel
> part) which ships 2.6.31.

Distros can easily add additional patches to their kernel if they wish
to keep the .31 kernel alive longer.  I am only one person, and can not
maintain 3 different kernel trees and remain sane.

> Every distribution has a release policy and switching from .3x to
> .3(x+1) on the road isn't sometimes desirable because of the
> regression risks. I can't risk to switch to .32 as I'm still seeing
> very very serious regression reports on LKML.
> 
> We just switched from 2.6.30.10 to 2.6.31.9 because I thought that it
> was stabilized and I was hoping that .31 will be a long term
> maintained release :) Then the next day I saw the announcement from
> you saying that 2.6.31.10 will be the last release of .31 series :)

You aren't the first to think that .31 would be a "long term" kernel.  I
have never stated this, and I wonder where that rumor came from.

> I spotted 3 very annoying regressions in a 3-day period just after switching to 2.6.31:
>  - boot hangs with AMD Athlon XP processors (#15075),

Only with debug option enabled.

>  - shutdown hangs on some *apparently* Pentium 4 processors (#15073),
>  - Governor failures on some systems because of BUG in MCE code (#14521)
> 
> The 1st and the 3rd one were injected during 2.6.31 merge window, so
> they were regressions that should have been caught already
> but to not fix them in 2.6.31.y would be an option as they were always
> in 2.6.31.y from 2.6.31 to 2.6.31.11.

Please send stable@kernel.org fixes for these problems, otherwise I have
no idea that they need to be included.

> *but*
> 
> The commit causing the 2nd one was accepted during 2.6.31.10 stable
> review. To accept a bugfix which causes a more serious regression
> is somewhat inacceptable for me. You announce the end-of-life of
> 2.6.31 with 2.6.31.10 with a really serious regression injected.

bugs happen.

> I don't try to blame anyone as I really really appreciate the work
> done by all the people in this list but unless some release policy
> isn't written for kernel releases, there will always be such
> annoyances :)
> 
> For example, I'm hopelessly waiting for a long-term-supported kernel
> like .27. Was it because someone liked the number 27 or something
> else?
> Will it happen again? If yes will this decision made public before the
> release?

Yes, I will be maintaining the .32 kernel in a "long-term" manner.  I
have mentioned it before to a number of people, but don't know if I've
done any "official" announcement.  Things get lost in the lkml volume at
times.

> Again, please please don't take the whole e-mail personal, I'm just
> describing a downstream kernel package maintainer's problems :)

Hey, that's my day-job, I know the problems well.

Ok, to help you solve this issue, I will be willing to do one more .31
release after this one.  Just send me the git commit ids of the patches
you wish for me to include, and I will do so.

Sound good?

thanks,

greg k-h
