Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXFBSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXFBSA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 14:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbXFBSAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 14:00:19 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53895 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760895AbXFBSAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 14:00:17 -0400
Date: Sat, 2 Jun 2007 14:00:00 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: <Pine.LNX.4.61.0706021916000.5076@yvahk01.tjqt.qr>
Message-ID: <alpine.DEB.0.99.0706021357070.24195@sigma.j-a-k-j.com>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
 <20070601181414.GC7968@redhat.com> <20070601112225.80a8be84.akpm@linux-foundation.org>
 <20070601182835.GC16529@redhat.com>
 <Pine.LNX.4.61.0706021916000.5076@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > >  > Explain what we use Acked-by: for, and how it differs from Signed-off-by:
> > > >  > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > >  > +
> > > >  > +If a person was not directly involved in the preparation or handling of a
> > > >  > +patch but wishes to signify and record their approval of it then they can
> > > >  > +arrange to have an Acked-by: line added to the patch's changelog.
> > > > 
> > > > Acked-by: Dave Jones <davej@redhat.com>
> > > 
> > > What, no Tested-by: ?
> >
> >Heh. Indeed.  I think there's room for both fwiw.
> 
> Too verbose. Suggest a typedef.
> 
> 	Signed-off-and-tested-by: Foo J. Bar <addy@corps>

Signed-off-by: should imply Tested-by:, with the exception of the final 
Signed-off-by: when it's merged into a tree. Tested-by:, if it really is 
necessary or useful, should be reserved for only those who test something 
but weren't involved in its development. Adding it to the tag is 
unnecessary unless somebody thinks there's a serious problem with untested 
patches being introduced by first-hand maintainers that a forced reminder 
would remedy.
