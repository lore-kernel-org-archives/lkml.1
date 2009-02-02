Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZBBIJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZBBIJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZBBIJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:09:16 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:48941 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZBBIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:09:15 -0500
Date: Mon, 2 Feb 2009 01:09:14 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Subject: Re: [PATCH F 12/12] OMAP2/3 McBSP: add temporary clockdomain fix
 for McBSP virtual clocks
In-Reply-To: <20090131114226.GE1394@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902020105370.888@utopia.booyaka.com>
References: <20090128193326.2396.9437.stgit@localhost.localdomain> <20090128193531.2396.91172.stgit@localhost.localdomain> <20090131114226.GE1394@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:35:33PM -0700, Paul Walmsley wrote:
> > The McBSP driver uses virtual clocks to handle enabling and disabling
> > its hardware clocks.  These virtual clocks have no associated
> > clockdomain. After commit 60b8b431e47d8c5b8c02a2e4fa9af388aae20790,
> > this prevents the McBSP clocks from registering correctly.
> > Resolve this for the short term by using virt_opp_clkdm for these clocks.
> > These McBSP virtual clocks should be removed, but such a fix would require
> > significant changes to the McBSP drivers that would require testing on
> > OMAP1, 2, and 3 platforms.
> 
> With either my clkdev patches or the spinlock fixing for mcbsp, this patch
> seems to be redundant.

Indeed.  It was included so the patch set would work if your tree didn't 
have Stanley's McBSP patch applied; I don't think it's made it up to 
mainline.


- Paul
