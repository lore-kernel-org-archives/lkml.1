Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803Ab0AISSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0AISSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 13:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771Ab0AISSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 13:18:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741Ab0AISSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 13:18:09 -0500
Date: Sat, 9 Jan 2010 10:17:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jerome Glisse <glisse@freedesktop.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
In-Reply-To: <20100109120141.GA4319@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001091012080.7821@localhost.localdomain>
References: <201001090045.33784.rjw@sisk.pl> <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain> <alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie> <20100108185041.7aae6c01@jbarnes-piketon> <20100109120141.GA4319@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Jerome Glisse wrote:

> On Fri, Jan 08, 2010 at 06:50:41PM -0800, Jesse Barnes wrote:
> > 
> > Linus, can we ever drop those old paths?  Maybe after the new bits have
> > been around for awhile?  Users of really old userspace stacks would
> > lose 3D support, but they'd still have 2D, so it wouldn't be a complete
> > break.  The non-KMS paths sometimes break like this anyway without us
> > noticing (especially some of the weirder 3D paths)...
> > 
> > Just thinking out loud, we could really kill a lot of really bad code...
> 
> I among those who would love such things to happen :)

I don't want to drop it _yet_, but "ever"? Sure. When people are sure that 
KMS actually handles all the cases that old X does (maybe that's true 
now), and we've had more than just a couple of kernel releases of _stable_ 
Intel KMS, I suspect we can start thinking about "ok, nobody seriously 
uses 3D on Intel integrated graphics _and_ updates the kernel".

The fact that they'd still have a working X setup would make it generally 
much more palatable, I think. 

But we definitely need more than just a couple of kernel releases. So 
we're talking timescales of "more than a year of stable code". Whether 
that is "six months from now" or "two years from now", I can't judge. 

And people can try to convince me to be more or less aggressive about it, 
so take the above as a more of a personal opinion that is open to 
change than anything definite and final.

		Linus
