Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZAaLmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZAaLmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 06:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZAaLmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 06:42:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34080 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZAaLmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 06:42:37 -0500
Date: Sat, 31 Jan 2009 11:42:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Subject: Re: [PATCH F 12/12] OMAP2/3 McBSP: add temporary clockdomain fix for McBSP virtual clocks
Message-ID: <20090131114226.GE1394@n2100.arm.linux.org.uk>
References: <20090128193326.2396.9437.stgit@localhost.localdomain> <20090128193531.2396.91172.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128193531.2396.91172.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:35:33PM -0700, Paul Walmsley wrote:
> The McBSP driver uses virtual clocks to handle enabling and disabling
> its hardware clocks.  These virtual clocks have no associated
> clockdomain. After commit 60b8b431e47d8c5b8c02a2e4fa9af388aae20790,
> this prevents the McBSP clocks from registering correctly.
> Resolve this for the short term by using virt_opp_clkdm for these clocks.
> These McBSP virtual clocks should be removed, but such a fix would require
> significant changes to the McBSP drivers that would require testing on
> OMAP1, 2, and 3 platforms.

With either my clkdev patches or the spinlock fixing for mcbsp, this patch
seems to be redundant.
