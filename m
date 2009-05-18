Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZERKGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZERKGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZERKFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:05:42 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50895 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbZERKFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:05:41 -0400
Date: Mon, 18 May 2009 11:05:40 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090518100540.GB21150@sucs.org>
References: <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org> <20090515040904.GA32357@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515040904.GA32357@hash.localnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 12:09:04AM -0400, Bob Copeland wrote:
> 
> This is too ugly to live, but I'd like to know if you can reproduce
> with this patch.  If it still happens, then I guess it's back to

I'll try but to this day I still have no clue how to trigger this issue.
I can seemingly go days/weeks without seeing it...

> debugging patches.  I'd love to be able to replicate this here :(

I just wish I could reproduce it on demand. It's so erratic I can't help
feeling the circumstances that make it happen are beyond my control
(e.g. someone else's access point being powered on at that moment /
hardware failure). It's happened in three different places (two houses
and one University) with different access points (one old 802.11b AP
doing WEP, enterprise 802.11g APs at the University doing WPA2 and a
recently purchased ADSL modem/AP doing WPA2 again doing 802.11g). At all
sites it has been possible to see multiple APs (although at the
University it's most likely those APs are going to be on the same
network/configured similarly). It only seems to happen while associated
with an AP. It does not need the computer to have been suspend to
happen. It can happen during the first connection to the AP (no need to
have roamed). So far the issue has never occurred in the first 1000
seconds of being connected to an AP.

One other thing I noticed was that one day I suspend and went home and I
found the AP I was connected to was still showing up in iwlist scan even
though it had been many hours (at least 10) since the last beacon had
been received from that AP ("Extra: Last beacon:" had a very big value).
The AP did not go away until after a reboot.

-- 
Sitsofe | http://sucs.org/~sits/
