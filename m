Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbXIMBn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbXIMBn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXIMBnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:43:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55296 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbXIMBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:43:50 -0400
Date: Thu, 13 Sep 2007 10:43:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] ssb: Make pcmciahost depend on PCMCIA=y
Message-ID: <20070913014333.GA26541@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michael Buesch <mb@bu3sch.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070912021100.GB26827@linux-sh.org> <200709121209.10068.mb@bu3sch.de> <20070912101745.GA23417@linux-sh.org> <200709121259.00700.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709121259.00700.mb@bu3sch.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 12:59:00PM +0200, Michael Buesch wrote:
> On Wednesday 12 September 2007 12:17:45 Paul Mundt wrote:
> > On Wed, Sep 12, 2007 at 12:09:09PM +0200, Michael Buesch wrote:
> > > There we go. The usual SELECT dependency hell again...
> > > Would changing SSB_PCMCIAHOST_POSSIBLE to tristate also fix it?
> > > What would be the sideeffects?
> > > 
> > I tried that first, if you do that you have to change the default to
> > SSB && PCMCIA, and then anything that depends on it also has to be a
> > tristate. That worked ok for SSB_PCMCIAHOST, but it didn't work ok for
> > the b43 wireless + PCMCIA, which is why I opted for the PCMCIA=y thing
> > instead, which makes sure that SSB_PCMCIAHOST can't be enabled if PCMCIA
> > is modular.
> 
> Ok, so much for "SELECT is easy and it works if used correctly..." :)
> Well, let's apply that patch then. It needlessly restricts the
> choice to not allow modular pcmcia in that case, though.
> 
That is the compromise, yes. Feel free to propose a better solution ;-)
