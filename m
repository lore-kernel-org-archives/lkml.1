Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZF2S2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZF2S2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZF2S2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:28:01 -0400
Received: from kroah.org ([198.145.64.141]:52893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZF2S2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:28:00 -0400
Date: Mon, 29 Jun 2009 11:27:38 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: intel-gfx@lists.freedesktop.org, woodys@xandros.com,
       stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, Jesse Barnes <jbarnes@virtuousgeek.org>,
       apw@canonical.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] [Intel-gfx] Intel 915GM MCHBAR bug
Message-ID: <20090629182738.GD3901@kroah.com>
References: <4A242C81.6020906@cs.helsinki.fi> <4A298971.5080006@xandros.com> <4A2A0951.1020608@cs.helsinki.fi> <20090605232711.d8503262.akpm@linux-foundation.org> <4A2A0E8C.1010109@cs.helsinki.fi> <20090606212759.31970fae@jbarnes-x200> <20090609150757.4a2109a9@jbarnes-x200> <20090609152828.d82528f3.akpm@linux-foundation.org> <20090629173308.GB3901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629173308.GB3901@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 10:33:08AM -0700, Greg KH wrote:
> On Tue, Jun 09, 2009 at 03:28:28PM -0700, Andrew Morton wrote:
> > On Tue, 9 Jun 2009 15:07:57 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > > > Andrew Morton wrote:
> > > > > > These might end up being 2.6.30.1 material.
> > > > > 
> > > > > Yes, agreed completely. We probably want ACK from Jesse and Bjorn,
> > > > > though.
> > > > 
> > > > I'm ok with it being 2.6.30.1 stuff, but given the significance of the
> > > > change we were worried about putting it into 2.6.30 late in the cycle.
> > > > But as you say, it's a very important performance fix for many
> > > > machines...
> > > > 
> > > > Anyway, Eric may already have it merged.  Eric?
> > > > 
> > > 
> > > It's merged now into the drm-intel-next tree, and therefore queued for
> > > the merge window.
> > 
> > <hunts around for a while>
> > 
> > This? http://git.kernel.org/?p=linux/kernel/git/anholt/drm-intel.git;a=commitdiff;h=d765898970f35acef960581f678b9da9d5c779fa;hp=1b8e69662e1a086878bf930a6042daf7f8a076cc
> > 
> > It doesn't have cc:stable in the changelog, so there's a reasonable
> > chance that it will get lost.
> > 
> > The -stable guys troll the commit list looking for mainline commits
> > which mention stable@kernel.org in the changelog.
> 
> I got it for the next .30 release.

I take it back.  It doesn't build properly on 2.6.30, can someone
backport commit d765898970f35acef960581f678b9da9d5c779fa to the 2.6.30
tree and send it to stable@kernel.org so that we can apply it to resolve
this issue?

And is it relevant to 2.6.29 as well?

thanks,

greg k-h
