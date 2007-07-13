Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXGMMcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXGMMcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbXGMMb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:31:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:38469 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbXGMMb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:31:57 -0400
Subject: Re: [Linux-fbdev-devel] [patch 0/4] Cell SPE logos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       James Simmons <jsimmons@infradead.org>, cbe-oss-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.62.0707131108320.18802@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
	 <20070712160621.644d78d2.akpm@linux-foundation.org>
	 <Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
	 <20070713020621.e8f2e4ce.akpm@linux-foundation.org>
	 <Pine.LNX.4.62.0707131108320.18802@pademelon.sonytel.be>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 22:30:58 +1000
Message-Id: <1184329858.6059.217.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 11:09 +0200, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Andrew Morton wrote:
> > On Fri, 13 Jul 2007 10:52:10 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > > > > Summaries:
> > > > >   [1] fbdev: extract fb_show_logo_line()
> > > > >   [2] fbdev: Add fb_append_extra_logo()
> > > > 
> > > > This one does give additional code and data to all fbdev users while only
> > > > being useful to cell machines.  Should we fix that?
> > > 
> > > I can protect it by #ifdef CONFIG_PPC_CELL (as long as there are no other
> > > users). Would that be OK?
> > 
> > umm, your call.  If that makes sense, sure.
> 
> I just don't like putting platform-specific checks in common code.
> 
> Perhaps I better add CONFIG_FB_LOGO_EXTRA and make it depend on
> CONFIG_PPC_CELL?

I hate depends when it's not a dependency... the logo extra code doesn't
-depend- technically on cell (it doesn't call cell only stuff). However,
cell wants it enabled, thus I'd rather use either the "default y if
PP_CELL" construct or select it from the cell option.

Ben.
 

