Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0CCAej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:34:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343Ab0CCAeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:34:37 -0500
Date: Tue, 2 Mar 2010 16:34:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [git pull] drm request 2
In-Reply-To: <21d7e9971003021548u7509651fyfc875d4e30472486@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003021630250.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>  <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>  <alpine.DEB.2.00.1003022305070.4099@skynet.skynet.ie> 
 <21d7e9971003021527t41268786q302a218ffe410763@mail.gmail.com>  <alpine.LFD.2.00.1003021536280.3616@localhost.localdomain> <21d7e9971003021548u7509651fyfc875d4e30472486@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Dave Airlie wrote:
> 
> So can we get linux-next builds to build with *your* Kconfig? This should
> cut down the amount of crap you see considerably.

No.

Dave, _think_ about what you're saying.

The absolute last thing we want to do is to make it easier for crap to 
flow through the system.

We don't want to make it easier to hide problems. 

I think we might want to instead extend on the tests that linux-next does. 
For example, STAGING should generally always compile.

There are exceptions - major "change the world" changes where staging 
drivers might not be updated in as timely a manner as other drivers, but 
they should be exceptions, not the rule.

If a driver really doesn't even compile, it should be marked BROKEN, not 
STAGING.

			Linus
