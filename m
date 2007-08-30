Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXH3NPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXH3NPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXH3NPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:15:23 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4087 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbXH3NPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:15:20 -0400
Date: Thu, 30 Aug 2007 08:36:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
Message-ID: <20070830123609.GA5140@tuxdriver.com>
References: <2713029743177393055@pripojeni.net> <280951420471148977@pripojeni.net> <20070828171330.GD29343@infradead.org> <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:38:09AM +0300, Nick Kossifidis wrote:
> 2007/8/28, Christoph Hellwig <hch@infradead.org>:

> > Also this whole patch seems rather pointless.  It saves only
> > very little and turns the driver into a complete ifdef maze.

> Also most
> people will use 5212 code only, 5211 cards are on some old laptops and
> 5210, well i couldn't even find  a 5210 for actual testing :P

FWIW, I'd bet dollars to donuts that distros will enable them all
together.

Is saving code space the only reason to turn these off?  How much
space do you save?

Is there some way you can isolate and/or limit the number of ifdef
blocks further?  If so, we might consider a version of this patch
that depends on EMBEDDED or somesuch...?

John
-- 
John W. Linville
linville@tuxdriver.com
