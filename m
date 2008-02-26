Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbYBZUD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbYBZUD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYBZUDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:03:49 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4348 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYBZUDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:03:47 -0500
Date: Tue, 26 Feb 2008 14:48:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
       johannes@sipsolutions.net
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Message-ID: <20080226194838.GD3013@tuxdriver.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802252104.32416.chris2553@googlemail.com> <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com> <200802261911.39577.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802261911.39577.chris2553@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:11:39PM +0000, Chris Clayton wrote:

> Sorry, but that's not the case. I find the same results as without the 
> patches. With the parameter set to 'pid', the network connection fails very 
> quickly, but with it set to 'simple' I can ping and ftp files to and from my 
> laptop as much as I like and the connection stays up. In fact, if anything 
> the patches seem to have made the network even more fragile, in that it fails 
> almost instantly once I start some network activity ( < 10 pings).
> 
> I'm sure this is not the hardware - it works perfectly with Windows XP, with 
> 2.6.23.14 plus the out-of-tree rt61 driver from serialmonkey, with the 
> in-tree driver from 2.6.24.x and with 2.6.25-rc3 with the mac82011's 
> ieee80211_default_rc_algo parameter set to 'simple'.

At last!  Vindication for insisting that we keep 'simple' around!
Bwahahaha! :-)

So, am I to understand that 'pid' works find for you with rtl8180?
If so, then I wonder if Stefano and Ivo can help us figure-out
what kind of problem is sensitive to both driver _and_ rate control
algorithm?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
