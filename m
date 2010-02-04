Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab0BDRg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:36:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46536 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625Ab0BDRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:36:14 -0500
Date: Thu, 4 Feb 2010 17:36:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off
	switch out of staging."
Message-ID: <20100204173602.GA19855@srcf.ucam.org>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie> <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie> <20100202081727.GA6788@elte.hu> <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com> <20100202154656.GD27314@elte.hu> <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com> <20100204062619.GA29154@elte.hu> <20100204071705.GA28403@elte.hu> <20100204164859.GA17878@srcf.ucam.org> <20100204170826.GA16397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204170826.GA16397@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 06:08:26PM +0100, Ingo Molnar wrote:

> Well, once i applied the revert i got no more hangs or crashes today, in lots 
> of bootups. This is fully repeatable - if i re-apply that commit with the 
> config i sent the hang happens again.

If you leave the commit applied, use that config and then enable Radeon 
KMS under staging, do you get the hang?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
