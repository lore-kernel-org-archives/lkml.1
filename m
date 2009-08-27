Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZH0UNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZH0UNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZH0UNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:13:18 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:50910 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZH0UNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:13:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALCFlkpR92Cn/2dsb2JhbADYbAmEEAU
Date: Thu, 27 Aug 2009 22:13:17 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: roel.kluin@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] txx9wdt.c:52: Fix txx9wdt_probe() cleaning up after
	errors
Message-ID: <20090827201317.GH29382@infomag.iguana.be>
References: <4A93ACDA.8030000@gmail.com> <20090827.235200.21363768.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827.235200.21363768.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Atsushi,

> > Make txx9wdt_probe() clean up after errors.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > Any comments?
> 
> Well, why is this patch needed?  I intentionally omitted iounmap and
> release_mem_region because devres guarantee these resources are freed
> on probe failure.  Or are there any leaks?

My opinion: a driver should do proper clean-up on probe failures because
1) this makes clean and robust code and shows that you know what you are doing
2) to avoid having to search for leaks if there are any. See the NULL pointer story...

Kind regards,
Wim.

