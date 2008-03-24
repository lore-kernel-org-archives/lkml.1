Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYCYOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYCYOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYCYOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:42:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3836 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754614AbYCYOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:42:50 -0400
Date: Mon, 24 Mar 2008 17:24:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nicholas Miell <nmiell@comcast.net>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080324162428.GA4206@ucw.cz>
References: <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com> <20080321172644.GG2346@one.firstfloor.org> <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com> <20080322071755.GP2346@one.firstfloor.org> <1206170695.2438.39.camel@entropy> <20080322091001.GA7264@one.firstfloor.org> <1206180991.2438.43.camel@entropy> <20080322142949.GB10687@one.firstfloor.org> <20080323132517.GB4580@ucw.cz> <20080323170827.GB5082@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323170827.GB5082@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-23 18:08:27, Andi Kleen wrote:
> > Is this good idea? Attacker can send you binary with the bitmap
> > inverted, it is now slow on your system and signature matches.
> 
> The first run will fix up any missing bits in the bitmap. Right 
> now it cannot get rid of unnecessary pages though unless you
> disable early_fault.
> 
> > ...might be important for benchmarks... 'here, see, Oracle is slow.
> > Feel free to verify the signature'.
> > 
> > ...ok, I guess it is not too serious, because it is similar to
> > fragmentation....
> 
> It is actually far better than fragmentation because the bitmap
> loader does IO always in big chunks -- not much seeking will go on. 
> The only problem is some wasted mmeory and more IO bandwidth
> usage (but typically binaries are not bigger than a few MB so 
> it's not too dramatic)
> 
> So in summary I don't think it's an issue.

Agreed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
