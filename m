Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0BDR7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:59:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42310 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab0BDR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:59:39 -0500
Date: Thu, 4 Feb 2010 17:59:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off
	switch out of staging."
Message-ID: <20100204175928.GA20595@srcf.ucam.org>
References: <20100202081727.GA6788@elte.hu> <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com> <20100202154656.GD27314@elte.hu> <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com> <20100204062619.GA29154@elte.hu> <20100204071705.GA28403@elte.hu> <20100204164859.GA17878@srcf.ucam.org> <20100204170826.GA16397@elte.hu> <20100204173602.GA19855@srcf.ucam.org> <20100204175445.GB27361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204175445.GB27361@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 06:54:45PM +0100, Ingo Molnar wrote:

> But you could claim that it's not a regression because 1) technically the 
> code got introduced in drivers/staging/, and staging drivers are not on the 
> regression list 2) the Kconfig value is default-off so it can only harm those 
> who got lured by a new Kconfig value popping up in -rc7 in a well working 
> driver they already have enabled.
> 
> So the moving of driver functionality from drivers/staging/ to drivers/ is a 
> grey area it appears. Wouldnt it have been better to do this in the next 
> merge window, as all other drivers do? It's not new hardware enablement 
> either, it's feature enablement for an existing driver.

The reason the option was in staging (as has been mentioned before) was 
because the ABI wasn't felt to be stable enough. Upstream is now willing 
to commit to that stability, so now seems as good a time to move it as 
any. There's no code change and there's no default configuration change, 
so I really can't see any way that it can be classed as a regression.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
