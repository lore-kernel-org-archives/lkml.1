Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZCMJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZCMJwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZCMJwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:52:20 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:42841 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZCMJwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:52:19 -0400
Date: Fri, 13 Mar 2009 09:52:13 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090313095213.GA14250@silver.sucs.org>
References: <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312061047.GA13401@silver.sucs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 06:10:48AM +0000, Sitsofe Wheeler wrote:
> On Mon, Mar 09, 2009 at 08:43:44PM -0400, Bob Copeland wrote:
> > 
> > Ok, here's a patch, it survived a few hours of testing with 3 rx buffers.
> > Sitsofe, it's worth a try applying this one, even though it probably
> > isn't it :)
> 
> I applied it yesterday and all seemed well for a few hours (suspending
> and resuming a fair bit too) so I left it overnight but when I looked
> this morning this is what I found:
> 
> Just a quick heads up - I will probably lose the ability to "easily"
> test this problem by the end of this month...

OK I left things overnight and this happened again with the again with
the patch installed. This time I had an ftrace filter in place and I
think the function trace goes back around 27 minutes. The dmesg doesn't
report any jumbo frame errors but it does mention ath5k phy0: noise
floor calibration timeout about two hours before the poison is
overwritten.

The dmesg and trace can be found on
http://sucs.org/~sits/test/eeepc-debug/20090313/ .

The one I'll note is that every time this issue has occurred I've been
connected to encrypted networks (both WPA and WEP).

-- 
Sitsofe | http://sucs.org/~sits/
