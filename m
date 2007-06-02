Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXFBTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXFBTGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbXFBTGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:06:40 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55535 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbXFBTGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:06:39 -0400
Date: Sat, 2 Jun 2007 21:07:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-ID: <20070602190740.GB10768@uranus.ravnborg.org>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <20070601181414.GC7968@redhat.com> <20070601112225.80a8be84.akpm@linux-foundation.org> <20070601182835.GC16529@redhat.com> <Pine.LNX.4.61.0706021916000.5076@yvahk01.tjqt.qr> <alpine.DEB.0.99.0706021357070.24195@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706021357070.24195@sigma.j-a-k-j.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 02:00:00PM -0400, John Anthony Kazos Jr. wrote:
> > > > >  > Explain what we use Acked-by: for, and how it differs from Signed-off-by:
> > > > >  > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > >  > +
> > > > >  > +If a person was not directly involved in the preparation or handling of a
> > > > >  > +patch but wishes to signify and record their approval of it then they can
> > > > >  > +arrange to have an Acked-by: line added to the patch's changelog.
> > > > > 
> > > > > Acked-by: Dave Jones <davej@redhat.com>
> > > > 
> > > > What, no Tested-by: ?
> > >
> > >Heh. Indeed.  I think there's room for both fwiw.
> > 
> > Too verbose. Suggest a typedef.
> > 
> > 	Signed-off-and-tested-by: Foo J. Bar <addy@corps>
> 
> Signed-off-by: should imply Tested-by:, with the exception of the final 
> Signed-off-by: when it's merged into a tree.
Subsystem maintainers cannot test each and every submission.
Sometimes due to lack of HW at other times simply due to lack of time.

Signed-off-by is exactly one thing - a way to show the path
a patch take. Then people on the path may have done more or less review/test.

Lot's of people confuses signed-of-by with acked-by btw - but this is waht this
patch should correct.

	Sam
