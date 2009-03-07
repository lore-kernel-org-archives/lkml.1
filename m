Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZCGNfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZCGNfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 08:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZCGNfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 08:35:00 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4214 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCGNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 08:34:59 -0500
Date: Sat, 7 Mar 2009 08:34:48 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090307133448.GB13663@hash.localnet>
References: <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090307044732.GA13663@hash.localnet> <20090307080422.GA29341@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307080422.GA29341@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 08:04:22AM +0000, Sitsofe Wheeler wrote:
> On Fri, Mar 06, 2009 at 11:47:32PM -0500, Bob Copeland wrote:
> > I saw _get_tsf64 in the trace; were you using ad-hoc/ibss mode, or 
> > is that just a weird artifact?
> 
> Sounds like a werid artifact - I only (intentionally) connect to access
> points.

Ok thanks, nevermind, that is just ath5k_extend_tsf being inlined.

-- 
Bob Copeland %% www.bobcopeland.com

