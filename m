Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0CDXUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:20:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558Ab0CDXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:20:02 -0500
Date: Thu, 4 Mar 2010 15:19:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>  <20100304190450.GA23807@srcf.ucam.org>  <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>  <20100304192524.GA24253@srcf.ucam.org>
  <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>  <20100304195302.GA24856@srcf.ucam.org>  <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>  <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>  <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
 <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Dave Airlie wrote:
> 
> Its nouveau project not X not DRM, stop generalising the situation.

Is it really just nouveau? I've not looked, but I bet the intel driver and 
the radeon driver have _exactly_ the same "oh, I'm the wrong version, I 
will now kill myself" behavior.

I certainly seem to remember some similar issues with the intel driver 
long long ago.

What would happen if I changed DRIVER_PATCHLEVEL to 1 for the i915 driver? 
Would it try to handle it gracefully? Or are we in the same situation that 
the intel driver guys can never fix anything fundamental without doing a 
whole flag day?

			Linus
