Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbXKZQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbXKZQw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbXKZQwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:52:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4029 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754750AbXKZQwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:52:49 -0500
Date: Mon, 26 Nov 2007 12:27:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20071126122706.GA5167@ucw.cz>
References: <20071125161631.GA21947@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125161631.GA21947@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-11-25 17:16:31, Adrian Bunk wrote:
> This patch removes the EXPERIMENTAL option and all dependencies on 
> EXPERIMENTAL because they are pointless.
> 
> Complete rationale:
> - Many people and all distributions are currently forced to enable
>   CONFIG_EXPERIMENTAL since the options for many device drivers depend
>   on this option.
>   I have yet to see someone not being able to install his favorite
>   distribution on his computer only because the distribution did choose
>   to disable all SATA drivers with dependencies on EXPERIMENTAL in their
>   kernels...
> - History has shown that often the dependency on EXPERIMENTAL is not
>   removed when the code has proven usable.
>   As an example, is our NFSv4 support really still in an
>   "alpha-test phase" [1], or is it already ready for being used?
>   I don't know the answer in this specific case, but I wouldn't answer
>   "still in an alpha-test phase" only based on the fact that the NFSv4
>   options still depend on EXPERIMENTAL.
> - It might have been differently 10 years ago, but today everything that
>   is available in a released kernel should also be in a usable state.
> 
> [1] quoted from the CONFIG_EXPERIMENTAL help text

I don't think this is good idea. But perhaps 'experimental' should be
removed from stuff that is really stable these days, like SATA?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
