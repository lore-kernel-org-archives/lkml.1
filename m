Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYHIHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYHIHDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYHIHDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:03:07 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:33657 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbYHIHDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:03:06 -0400
Date: Sat, 9 Aug 2008 09:03:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080809070344.GA11302@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <20080731182315.GA18060@linux-mips.org> <20080809025244.GB9794@uranus.ravnborg.org> <20080809030927.GA7766@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809030927.GA7766@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 12:09:28PM +0900, Paul Mundt wrote:
> On Sat, Aug 09, 2008 at 04:52:44AM +0200, Sam Ravnborg wrote:
> > On Thu, Jul 31, 2008 at 07:23:15PM +0100, Ralf Baechle wrote:
> > > I just did the necessary changes for MIPS and the first testbuild is running
> > > successfully so far.
> > > 
> > > One of the ugly things in the MIPS makefiles is the use of platform-
> > > specific headers in include/asm-mips/mach-* which contain platform specific
> > > headers.  Ideally those should be included through something like
> > > <mach/somefile.h> or <plat/something.h> and I think a directory like
> > > arch/$ARCH/$PLATFORM/include/plat/foobar.h could be a good place in the
> > > new scheme?  I assume other platforms have similar issues with subplatforms,
> > > processor sub-architectures etc.?
> > 
> > Hi Ralf.
> > 
> > Did you follow what arm have planned?
> > It looks like MIPS should do things in the same way so
> > we get some consistency.
> > 
> Where was this discussed? SH has the same issues obviously, but we've
> already settled on a scheme.

Looking again I realize this was only discussed on the arm kernel mailing list
and people involved was rmk, Harvaard and myself.

This was not optimal - sorry.

How much mips and arm solution differ I have not looked at closely.

	Sam
