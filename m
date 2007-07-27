Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXG0AjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXG0AjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbXG0Ais
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:38:48 -0400
Received: from mail4.kite.se ([212.214.165.225]:45291 "EHLO mail4.kite.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734AbXG0Air (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:38:47 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 20:38:47 EDT
Message-ID: <46A93C2B.4080902@kite.se>
Date: Fri, 27 Jul 2007 02:28:27 +0200
From: Magnus Naeslund <mag@kite.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Ray Lee <ray-lk@madrabbit.org>, "david@lang.hm" <david@lang.hm>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm> <2c0942db0707250855v414cd72di1e859da423fa6a3a@mail.gmail.com> <200707252316.01021.a1426z@gawab.com>
In-Reply-To: <200707252316.01021.a1426z@gawab.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> 
> Thanks for asking.  I'm rather surprised why nobody's noticing any of this 
> slowdown.  To be fair, it's not really a regression, on the contrary, 2.4 is 
> lot worse wrt swapin and swapout, and Rik van Riel even considers a 50% 
> swapin slowdown wrt swapout something like better than expected (see thread 
> '[RFC] kswapd: Kernel Swapper performance').  He probably meant random 
> swapin, which seems to offer a 4x slowdown.
> 

Sorry for the late reply.
Well I think I reported this or another swap/tmpfs performance issue earlier ( http://marc.info/?t=116542915700004&r=1&w=2 ), we got the suggestion to increase /proc/sys/vm/page-cluster to 5, but we never came around to try it.
Maybe this was the reason for my report to be almost entirely ignored, sorry for that.

Regards,
Magnus
