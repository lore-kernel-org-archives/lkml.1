Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbXGHTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbXGHTsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 15:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbXGHTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 15:48:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbXGHTsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 15:48:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video mode
Date: Sun, 8 Jul 2007 21:48:04 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Drake <dsd@gentoo.org>, Jan Beulich <jbeulich@novell.com>,
       linux-kernel@vger.kernel.org, zwane@infradead.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@pol.net>
References: <4678191D.76E4.0078.0@novell.com> <4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org>
In-Reply-To: <20070708111404.1486e73c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082148.04803.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 July 2007 20:14:04 Andrew Morton wrote:
> On Sun, 08 Jul 2007 09:27:55 -0400 Daniel Drake <dsd@gentoo.org> wrote:
> 
> > Andrew Morton wrote:
> > > On Sat, 30 Jun 2007 18:25:31 -0400 Daniel Drake <dsd@gentoo.org> wrote:
> > >> This patch solves a 2.6.20.11 (and 2.6.21) regression added by the patch 
> > >> titled "x86: Don't probe for DDC on VBE1.2"
> > >>
> > >> The regression caused the screen resolution to be incorrectly adjusted 
> > >> by 6 pixels. This patch makes it go back to normal again.
> > >>
> > >> https://bugs.gentoo.org/show_bug.cgi?id=181067
> > >>
> > >> Please apply this patch or discuss further :)
> > > 
> > > Well drat.  I didn't merge the patch because it conflicts with
> > > git-newsetup, and Peter believes that git-newsetup already contains an
> > > equivalent fix.  Testing 2.6.22-rc6-mm1 would confirm that.  Please.
> > 
> > 2.6.22-rc6-mm1 has the same problem (it is not fixed there).
> > 
> 
> Well damn, we've let this slide for too long.
> 
> Guys, 2.6.22 is days away.  Do we think that the below is safe to merge
> now?

I feel uneasy with the patch that late and i don't think the bug is 
particularly critical.

-Andi
