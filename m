Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0CDTxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:53:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56191 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab0CDTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:53:07 -0500
Date: Thu, 4 Mar 2010 19:53:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304195302.GA24856@srcf.ucam.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain> <20100304190450.GA23807@srcf.ucam.org> <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain> <20100304192524.GA24253@srcf.ucam.org> <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:41:22AM -0800, Linus Torvalds wrote:

> Is there some model of versioning inside X _except_ for the "it won't 
> work" kind of thing? Can we fix this going forward, so that you can have 
> _real_ versioning (ie multiple installed versions of a libdrm, the way you 
> can have concurrently multiple installed versions of glibc?)

There isn't. I don't think there's any intrinsic difficulty in doing so, 
other than the buildsystems and X's own unstable driver API.

> IOW, we have a real technical problem here. Are you just going to continue 
> to make excuses about it?

I'm not questioning the fact that it would be preferable to provide 
compatibility. But that compatibility doesn't come for free - someone 
has to implement it, and when your developer base is almost entirely 
made up of people who are doing this because they find it fun and 
interesting rather than because they're paid to, who's going to do it 
and what functionality is going to be delayed as a result?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
