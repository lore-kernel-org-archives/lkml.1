Return-Path: <linux-kernel-owner+w=401wt.eu-S1763032AbYA1WZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763032AbYA1WZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbYA1WY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:24:57 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46485 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYA1WYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:24:55 -0500
Date: Mon, 28 Jan 2008 23:24:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PATCH] kbuild updates
Message-ID: <20080128222455.GB4222@uranus.ravnborg.org>
References: <20080128212624.GA3842@uranus.ravnborg.org> <alpine.LFD.1.00.0801290901340.3505@www.l.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801290901340.3505@www.l.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 09:04:38AM +1100, Linus Torvalds wrote:
> 
> 
> On Mon, 28 Jan 2008, Sam Ravnborg wrote:
> > 
> > Please pull following patches for kbuild/kconfig and a few other areas.
> > 
> > Pull from:
> > 	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git
> 
> This conflicts with the SH updates (sh is also integrating 32/64-bit into 
> one tree now).
> 
> Since I don't know the SH tree or your changes, the probably fairly 
> trivial manual merge isn't an option (especially as I'm not at home and 
> doing this on a laptop with a less than ideal keyboard and smaller screen 
> than I'm used to).
> 
> So I hope you and Paul can resolve the conflicts and re-send.

As expected the conflicts were trivial and I fixed it up.
It was:
- The edit of the vmlinux.lds files
- The removal of make dep

Please pull the updated tree.

	Sam
