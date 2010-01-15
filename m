Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0AOQc7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159Ab0AOQc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:32:59 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:57036 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751297Ab0AOQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:32:58 -0500
Date: Fri, 15 Jan 2010 11:32:46 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Bowler <nbowler@draconx.ca>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
Message-ID: <20100115163246.GA4498@emergent.ellipticsemi.com>
Mail-Followup-To: Thomas Meyer <thomas@m3y3r.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Nick Bowler <nbowler@draconx.ca>, linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
 <20100113133357.67f9df6d@jbarnes-piketon>
 <4B4E403C.1050509@cs.helsinki.fi>
 <20100113165530.2a7e7645@jbarnes-piketon>
 <4B4F6D5F.10008@cs.helsinki.fi>
 <84144f021001150054m532cd1cdwbbdbab79b5924fb7@mail.gmail.com>
 <1263572080.2217.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263572080.2217.1.camel@localhost.localdomain>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:14 Fri 15 Jan     , Thomas Meyer wrote:
> Am Freitag, den 15.01.2010, 10:54 +0200 schrieb Pekka Enberg:
> 
> > So, any suggestions how I should proceed with figuring out the
> > "flashing" problem I still see with Jesse's patch? I can do a full git
> > bisect if it comes to that but it's going to be bit difficult to
> > determine if a commit is good or bad as there seem to be _two_
> > different problems both of which cause screen flickering.

You could apply Jesse's patch at each step during the bisection whenever
the LVDS downclocking commit is present.

> Does it look like the video in this bug, see attached video in the bug
> report:

As an aside, I tried to record a video of my LVDS downclocking issues
(which now appear to be different problems from Pekka's flickering).
The "lag" on screen updates is captured, but the flicker is not (I
probably need a camera that takes 120fps video to record it).

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
