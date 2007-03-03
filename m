Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXCCFfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXCCFfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 00:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbXCCFfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 00:35:25 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:2845 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933379AbXCCFfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 00:35:22 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       "David S. Miller" <davem@davemloft.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Yaroslav Halchenko <lists@onerussian.com>
Subject: Re: 2.6.21-rc2 radeon backlight
References: <87ps7uutsk.fsf@sycorax.lbl.gov>
	<20070301184531.b3aeafe3.akpm@linux-foundation.org>
	<87tzx35zkc.fsf@sycorax.lbl.gov>
	<20070302122920.a2967ebf.akpm@linux-foundation.org>
	<1172878338.11149.198.camel@localhost.localdomain>
Date: Fri, 02 Mar 2007 21:34:43 -0800
In-Reply-To: <1172878338.11149.198.camel@localhost.localdomain> (message from
	Richard Purdie on Fri, 02 Mar 2007 23:32:18 +0000)
Message-ID: <87k5xyq498.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie <rpurdie@rpsys.net> writes:

> I propose the following patch (I was previously waiting on James for
> this). It avoids backing out the problematic Kconfig changes but
> means a user has to explicitly enable the backlight via a kernel or
> module parameter.
>
> Can people with backlight problems try enabling them in Kconfig but
> applying the following patch? Hopefully I have you all cc'd.
>
> If it works I will add it to the other fix I have queued and pass to
> Linus via the backlight tree. If it doesn't, I will revert the
> problematic Kconfig changes for the next -rc.

with the patch applied i can boot into 2.6.21-rc2 and have a working
backlight when i enable radeon backlight support. so i guess the patch
successfully disables the new radeon backlight stuff on my thinkpad
and therefore it does what it says it does.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
