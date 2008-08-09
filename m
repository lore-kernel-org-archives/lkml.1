Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYHICuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYHICuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYHICt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:49:59 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:28560 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbYHICt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:49:58 -0400
Date: Sat, 9 Aug 2008 04:50:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080809025044.GA9794@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <20080729030647.GA11425@phobos.i.cabal.ca> <20080729032726.GA27460@uranus.ravnborg.org> <20080729142145.GC11425@phobos.i.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729142145.GC11425@phobos.i.cabal.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:21:45AM -0400, Kyle McMartin wrote:
> On Tue, Jul 29, 2008 at 05:27:26AM +0200, Sam Ravnborg wrote:
> > On Mon, Jul 28, 2008 at 11:06:47PM -0400, Kyle McMartin wrote:
> > > On Mon, Jul 28, 2008 at 10:05:00PM +0200, Sam Ravnborg wrote:
> > > > I am limited in time and resources at the moment but I
> > > > would be glad to help out as time permits should there
> > > > be any questions.
> > > > 
> > > 
> > > Just a quick one... I moved the files on parisc, but found we're still
> > > using include/asm-$foo/asm-offsets.h. A quick glance at Kbuild seems to
> > > indicate so. Is this expected?
> > Yes.
> > 
> > asm-offsets.h is a generated file and I wanted to avoid adding
> > generated files to arch/$ARCH/include.
> > 
> > It was also a less intrusive patch to keep it at the old location.
> > But I recall that it troubles me a bit before I got it
> > correct but the kbuild changes all take care of this.
> > 
> 
> Thanks for clarifying, Sam.

Any chance we can have this pushed towards Linus?

It would be nice to gat as many arch converted in this cycle as possible.

	Sam
