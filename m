Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZAZSYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZAZSYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZAZSYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:24:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbZAZSYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:24:08 -0500
Date: Mon, 26 Jan 2009 10:23:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm-fixes
In-Reply-To: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.0901261017380.5284@localhost.localdomain>
References: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave,
 you have some odd and slightly git usage model, which shows up in various 
commits. Lookie here as an example from comit 335041ed:

	Author: Jesse Barnes <jbarnes@virtuousgeek.org>  2009-01-22 04:22:06
	Committer: Dave Airlie <airlied@redhat.com>  2009-01-22 04:22:06
	
	    drm/i915: hook up LVDS DPMS property
	    
	    The LVDS output supports DPMS calls, but we never hooked up the property code,
	    so set property calls didn't actually do anything.  Implement a set_property
	    callback for the LVDS output so that the right thing happens.
	    
	    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

and this has a few issues that trigger my "Dave is doing something wrong" 
reaction:

 - The signed-off-chain is incomplete from the author to the committer.

   A _good_ sign-off will always have the sign-offs from the author and 
   the committer and everybody in between. This one does not. Clearly 
   Jesse did sign off on his work, but he is not listed as the committer: 
   you are. And that means that your sign-off is missing.

 - You are clearly lying about dates and/or dropping them.

   The dates for authorship and committing are the same, yet the author 
   and committer are clearly _not_ the same. You can try to convince me 
   that you committed Jesse's work the same second he sent it to you, but 
   quite frankly, I don't buy it. End result: you've done something to 
   drop the date information.

I don't know what tools you use, or what process the patches go through, 
but I do know that whatever your process is, it's losing information. 
Please fix it.

I've pulled, but I hope I won't have to see these issues in future pull 
requests.

			Linus
