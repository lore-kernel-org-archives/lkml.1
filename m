Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZCCUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZCCUEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZCCUD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:03:59 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:41032 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZCCUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:03:58 -0500
Date: Tue, 3 Mar 2009 20:03:52 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090303200352.GA8343@silver.sucs.org>
References: <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303041222.GA1238@hash.localnet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 11:12:22PM -0500, Bob Copeland wrote:
> On Thu, Feb 26, 2009 at 05:03:39PM +0000, Sitsofe Wheeler wrote:
> > 
> > Note that I was able to reproduce it again : )
> 
> By the way, here's the theoretical race I was alluding to.  ath5k_reset 
> happens pretty frequently when scanning, and it's possible that the rx
> tasklet is run on another cpu after interrupts are turned off, but

The machine where this fault happened is a single core non-symmetric
multithreading EeePC 900 with a Celeron M 900 using a voluntary preempt
kernel (so I doubt this is due to tasklets being run on another CPU)...

I am a bit unsure which patches you want me to be testing though...

-- 
Sitsofe | http://sucs.org/~sits/
