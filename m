Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0BDSPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:15:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39382 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0BDSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:15:48 -0500
Date: Thu, 4 Feb 2010 18:15:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off
	switch out of staging."
Message-ID: <20100204181540.GA20922@srcf.ucam.org>
References: <20100202154656.GD27314@elte.hu> <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com> <20100204062619.GA29154@elte.hu> <20100204071705.GA28403@elte.hu> <20100204164859.GA17878@srcf.ucam.org> <20100204170826.GA16397@elte.hu> <20100204173602.GA19855@srcf.ucam.org> <20100204175445.GB27361@elte.hu> <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204181218.GA6175@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 07:12:18PM +0100, Ingo Molnar wrote:
> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > The reason the option was in staging (as has been mentioned before) was 
> > because the ABI wasn't felt to be stable enough. Upstream is now willing to 
> > commit to that stability, so now seems as good a time to move it as any. 
> > There's no code change and there's no default configuration change, so I 
> > really can't see any way that it can be classed as a regression.
> 
> But that argument in essence renders the regression policy meaningless for 
> such code: just about any new driver feature under the sun could be shaped as 
> a Kconfig option, introduced via a drivers/staging Kconfig entry, and then 
> activated via a twoliner commit in a later -rc.

Before this patch, CONFIG_DRM_RADEON_KMS=y would crash your system on 
boot. After this patch, CONFIG_DRM_RADEON_KMS=y still crashes your 
system. There's certainly the argument that this means it's premature to 
make that change, but given that the same configuration behaves in the 
same way, it's clearly not a regression.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
