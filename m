Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYCTWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYCTWIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbYCTWIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:08:06 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2481 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594AbYCTWIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:08:04 -0400
Date: Thu, 20 Mar 2008 18:03:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, sam@ravnborg.org, dsd@gentoo.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH/RFC v2] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig
	symbol
Message-ID: <20080320220348.GC1330@tuxdriver.com>
References: <1206023695.16475.137.camel@johannes.berg> <20080320181310.GA17884@uranus.ravnborg.org> <1206038373.16475.150.camel@johannes.berg> <20080320.141307.173590705.davem@davemloft.net> <1206048106.16475.161.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206048106.16475.161.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 10:21:46PM +0100, Johannes Berg wrote:
> 
> > I think you're semantically testing the wrong thing.
> > 
> > It's not if unaligned accesses are supported, it's if they are
> > efficient enough or not.
> > 
> > For example, sparc64 fully handles unaligned accesses but taking the
> > trap to fix it up is slow.  So sparc64 "can" handle unaligned
> > accesses, but whether we want to set this symbol or not is another
> > matter.
> 
> Yeah, good point. Should I rename it to HAVE_EFFICIENT_UNALIGNED_ACCESS
> or similar? Or have it defined as some sort of number so you can make
> actually make tradeoffs? Like Dave Woodhouse suggested at some point to
> have get_unaligned() take an argument that indicates the probability...

Ugh...that sounds like premature optimization to me...

While I think Dave has a point, I don't think you should labor the word
choice too much.  Try to document it as clearly as possible and hope
for the best -- I hear that the arch maintainers are top notch! :-)

John

-- 
John W. Linville
linville@tuxdriver.com
