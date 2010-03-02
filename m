Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0CBXAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:00:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab0CBXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:00:03 -0500
Date: Tue, 2 Mar 2010 14:59:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Mar 2010, Dave Airlie wrote:
> 
> Same tree as yesterday with a warning + PPC build fix + fix for build on 
> x86 after PPC (I think I just validated Ingo).

Why is VGA_SWITCHEROO enabled by default?

We don't do things like that. New drivers and new features are _not_ 
enabled by default, unless there is some overriding reason why they should 
be. And I don't see that reason.

Please stop doing that. The whole "default y" is a f*cking disease. Yes, a 
developer always thinks that _his_ new code is so special and important 
that it should be enabled by default, BUT HE IS WRONG.

So remember: unless your new feature cures cancer, it should damn well not 
be enabled by default.

I disabled it in the merge, since I had to fix up that file anyway. But 
please don't make me do these so-called "evil merges" where I end up 
modifying the thing I merge.

			Linus
