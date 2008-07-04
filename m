Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbYGDGln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbYGDGln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbYGDGlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:41:31 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:54563 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbYGDGl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:41:29 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-164.messagelabs.com!1215153687!3124529!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 4 Jul 2008 08:41:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704064122.GA14806@digi.com>
References: <20080704063455.GA13999@digi.com> <20080704063938.GA12894@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080704063938.GA12894@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 06:41:23.0191 (UTC) FILETIME=[F995D070:01C8DDA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, Jul 04, 2008 at 08:34:55AM +0200, Uwe Kleine-König wrote:
> > Hello,
> >
> > I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> > the corresponding region the alphabetic ordering is broken.  Then I
> > inteded to fix that up for a trivial patch.  Next was to check the rest
> > of the file and there are so much misorderings that it's not sensible to
> > choose the trivial path anymore as there are currently 114 entries out
> > of order[1].
> >
> > Below is a script that shows the misorderings after applying the
> > following patch:
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e6c06fa..e9e36f8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1585,7 +1585,7 @@ S:      Supported
> >  EMBEDDED LINUX
> >  P:   Paul Gortmaker
> >  M:   paul.gortmaker@windriver.com
> > -P    David Woodhouse
> > +P:   David Woodhouse
> >  M:   dwmw2@infradead.org
> >  L:   linux-embedded@vger.kernel.org
> >  S:   Maintained
> >
> > IMHO there are two good ways to continue:
> >  - just ignore the misorderings; or
> >  - write a more clever script that not only shows the misorderings but
> >    fixes them and optimally let Linus directly apply it.
> >
> > I will try to come up with a script to prepare the second way.
> 
> If you succeed doing so it would be very good to fix up
> all mail entries to read:
> 
> M: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> so they are copy'n'paste friendly.
IMHO this would be a second step, but I like it.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
