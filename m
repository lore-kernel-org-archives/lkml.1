Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbXH3MgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbXH3MgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 08:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbXH3MgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 08:36:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36169 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbXH3Mf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 08:35:59 -0400
Date: Thu, 30 Aug 2007 13:35:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
Message-ID: <20070830123554.GA2176@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
References: <2713029743177393055@pripojeni.net> <280951420471148977@pripojeni.net> <20070828171330.GD29343@infradead.org> <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:38:09AM +0300, Nick Kossifidis wrote:
> It saves big chunks of code (not only initial register settings
> arrays) and we'll extend it's use more inside ath5k_hw.c Trust me this
> is a very useful step, eg. check out descriptor processing / setup or
> PHY functions (calibrate/channel set etc). For example AR5210 mac chip
> only comes with RF5110 phy chip so we can get rid of RF5111/RF5112
> code, AR5211 comes with RF5111 so we can get rid of RF5110 and RF5112
> code and AR5212 comes with RF5111 or RF5112 so we get rid of RF5110.
> This thing also saves lots of checks during runtime (some of them
> happen verry frequently, eg. durring descriptor processing). Also most
> people will use 5212 code only, 5211 cards are on some old laptops and
> 5210, well i couldn't even find  a 5210 for actual testing :P

If you're doing these checks in a hotpath something is badly wrong with
your architecture.
