Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXH2ESs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXH2ESs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXH2ESl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:18:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbXH2ESk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:18:40 -0400
Date: Wed, 29 Aug 2007 06:18:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Keith Packard <keith.packard@intel.com>
Subject: Re: CFS review
Message-ID: <20070829041827.GA8733@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708280737.53439.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> No need for framebuffer.  All you need is X using the X.org 
> vesa-driver.  Then start gears like this:
> 
>   # gears & gears & gears &
> 
> Then lay them out side by side to see the periodic stallings for 
> ~10sec.

i just tried something similar (by adding Option "NoDRI" to xorg.conf) 
and i'm wondering how it can be smooth on vesa-driver at all. I tested 
it on a Core2Duo box and software rendering manages to do about 3 frames 
per second. (although glxgears itself thinks it does ~600 fps) If i 
start 3 glxgears then they do ~1 frame per second each. This is on 
Fedora 7 with xorg-x11-server-Xorg-1.3.0.0-9.fc7 and 
xorg-x11-drv-i810-2.0.0-4.fc7.

	Ingo
