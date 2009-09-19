Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZISJHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZISJHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZISJHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:07:16 -0400
Received: from [195.41.46.236] ([195.41.46.236]:37297 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZISJHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:07:14 -0400
Date: Sat, 19 Sep 2009 11:07:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <michal.simek@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: microblaze: commit 95521585 breakage
Message-ID: <20090919090708.GD25877@merkur.ravnborg.org>
References: <1d3f23370909162246v308da10aga5c4c76d5584341b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d3f23370909162246v308da10aga5c4c76d5584341b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 03:46:26PM +1000, John Williams wrote:
> Hi Sam, Michal,
> 
> Your MicroBlaze arch makefile cleanup commit
> 9552158573f847aa429334bb97995bb290bb4b0d had a rather unfortunate
> error in it:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=950b260ed21fdb6fa5f18485dabb0b03488431fa
> 
> You intended to change CFLAGS_KERNEL to KBUILD_CFLAGS, but instead
> changed CFLAGS_KERNEL to KBUILD_KERNEL.
> 
> The result?  No CPU feature optimisations across the entire MicroBlaze
> kernel build :(
> 
> The fix is trivial - may I leave it to you to resolve and merge as
> soon as possible?  This is a pretty serious performance regression.

Agree with the analysis of John.

Michael - I leave it to you to fix it up.

	Sam
