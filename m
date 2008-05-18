Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755106AbYERQur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYERQur (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sun, 18 May 2008 12:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYERQuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:50:03 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:58850 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbYERQuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:50:00 -0400
Date: Sun, 18 May 2008 18:49:25 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: IPv6 slab leak (was: Re: dst cache overflow)
Message-ID: <20080518164924.GA4960@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org> <20071216073533.GA2706@gondor.apana.org.au> <20071216083828.GA512@yamamaya.is-a-geek.org> <20080317012513.GA3139@yamamaya.is-a-geek.org> <20080318185914.GA9275@yamamaya.is-a-geek.org> <20080323092125.GB2950@yamamaya.is-a-geek.org> <20080516194625.GA21570@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080516194625.GA21570@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> > Tobias Diedrich wrote:
> > > Tobias Diedrich wrote:
> > > 
> > > > just a reminder, the server is now running 2.6.24 and the leak is
> > > > still there.  I noticed there is a slab leak debug option and turned
> > > > it on, results should be visible in a few days I guess.
> 
> I'm upgrading to 2.6.25.4 now and I hope that "sit: Add missing
> kfree_skb() on pskb_may_pull() failure." finally fixes the bug. :)
> There also was some IPv6 related leak-fix in 2.6.24.something IIRC,
> but that one did not help unfortunately.

Ok, it's only been running for ~2 days now, but it very much looks
fixed now:
http://www.tdiedrich.de/~ranma/oni_20080518_route-year.png
http://www.tdiedrich.de/~ranma/oni_20080518_route-week.png
http://www.tdiedrich.de/~ranma/oni_20080518_route-day.png

Cheers,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
