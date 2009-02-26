Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZBZBLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZBZBLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZBZBLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:11:45 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:1048 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZBZBLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:11:45 -0500
Date: Wed, 25 Feb 2009 20:11:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090226011136.GB10577@hash.localnet>
References: <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A46AD4.3060007@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 10:47:00PM +0100, Jiri Slaby wrote:
> I added a check for this in rx tasklet some time ago, because I hit it.  
> So no fireworks really should happen ;).
>
> And yes, we ought to use this much better test (I knew nothing about  
> AR_RXDP reg) than mine.

Indeed, it lasted all day for me with only 3 buffers under load, lots of
packet loss though :)

-- 
Bob Copeland %% www.bobcopeland.com

