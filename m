Return-Path: <linux-kernel-owner+w=401wt.eu-S934707AbYBNV3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbYBNV3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764579AbYBNV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:28:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59500 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYBNV27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:28:59 -0500
Date: Thu, 14 Feb 2008 13:26:43 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: [stable] [GIT pull] hrtimer fixes
Message-ID: <20080214212643.GA18521@kroah.com>
References: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:19:23PM +0100, Thomas Gleixner wrote:
> Linus,
> 
> please pull hrtimer fixes from:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master
> 
> The first patch fixes an overflow problem, which is caused by missing
> checks in the relative to absolute time conversion in the futex
> code. It got caught by the WARN_ON() in clockevents_program_event().
> 
> The second patch prevents a false positive of the same WARN_ON().
> 
> Fixes are confirmed to solve http://lkml.org/lkml/2008/2/10/137

Are one of these needed in the stable tree?

If so, you can just add a:
	Cc: stable <stable@kernel.org>
to the signed-off-by area, and we (the stable tree developers) will get
an automated email when it goes into Linus's tree, with the git
changelog entry.

thanks,

greg k-h
