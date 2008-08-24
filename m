Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYHXRQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYHXRQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYHXRQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:16:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbYHXRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:16:26 -0400
Date: Sun, 24 Aug 2008 10:16:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [git pull] drm patches for 2.6.27 final
In-Reply-To: <alpine.DEB.0.82.0808240809170.15834@skynet.skynet.ie>
Message-ID: <alpine.LFD.1.10.0808241013510.3363@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0808240809170.15834@skynet.skynet.ie>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Aug 2008, Dave Airlie wrote:
> 
> So this has fixes for the SiS build with fbdev, a fix for a warning 
> reported by Jiri Slaby in the irq locking code, a fix for debugging the X 
> server startup sequence, r300/r500 radeon lockup fixes, Intel hw 
> instability fixes in the irq and hw status pages, and the biggest 
> bit is a fix for the backlight keys on a bunch of Intel laptops which is 
> enabled using opregion support from Matthew Garrett.

Quite frankly, I'm not going to take this.

None of what you describe sounds like regressions, and this is just TOO 
F*CKING LATE to take big changes like this, to a fragile subsystem that 
has historically easily introduced new regressions.

Can you please make a branch with ONLY REGRESSIONS, or fixes for major 
problems that don't introduce several thousand lines of new code?

Because you seem to be constantly unable to understand what "merge window" 
means. And I'm not going to take this kind of crap.

			Linus
