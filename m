Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZBWQog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZBWQog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBWQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:44:25 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3061 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZBWQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:44:24 -0500
Date: Mon, 23 Feb 2009 11:44:15 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090223164415.GA3558@hash.localnet>
References: <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com> <40f31dec0902230815x6b43fa50h41edfeead96822a3@mail.gmail.com> <20090223162103.GA3383@hash.localnet> <40f31dec0902230827j5c0f9f20je02c7fb02709f71e@mail.gmail.com> <20090223163032.GA3450@hash.localnet> <40f31dec0902230841m712acff4qe1c1617819f028be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31dec0902230841m712acff4qe1c1617819f028be@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 06:41:01PM +0200, Nick Kossifidis wrote:
> > No, that's intentional.  That was actually a bug we had at some point
> > (rs_more is a u8 so the bitwise AND overflowed).  The "!!" makes it zero
> > or one so it fits.
> >
> 
> AR5K_REG_MS is used for that, we should just shift it as we do with
> the other fields and btw i think we must change flags to be bool.

Fine with me, in fact I wrote it that way first but someone suggested
"!!" instead in a patch review.  Either way works.  Also ACK on using 
bool.

-- 
Bob Copeland %% www.bobcopeland.com

