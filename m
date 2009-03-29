Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZC2OYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZC2OYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZC2OYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:24:38 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46881 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZC2OYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:24:37 -0400
Date: Sun, 29 Mar 2009 15:24:32 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090329142432.GA15578@sucs.org>
References: <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320131437.GA30120@hash.localnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:14:37AM -0400, Bob Copeland wrote:
> 
> Looks like the skb was reused right after it was freed by the mac80211
> workqueue so that seems inline with the idea that the list is getting
> corrupted somehow.  On top of the last patch, would you mind running 
> this overnight?  It'll dump a lot of debug info, I'm really only 
> interested in the last 5 invocations of ath5k_debug_printrxbuffs or so
> before the poison.  During a scan you'll see lots of rx_start/rx_stop.

I've been away travelling for the past week and I move house on the 1st
April (which will make testing this much harder from then on) but I'll
try to get one final test in before the move.

Do you need an ftrace in addition to dmesg for this? If so is it better
to leave ieee calls out of the ftrace?

-- 
Sitsofe | http://sucs.org/~sits/
