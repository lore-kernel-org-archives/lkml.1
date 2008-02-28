Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbYB1WFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbYB1WFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYB1WE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:04:59 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:45999 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYB1WE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:04:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Thu, 28 Feb 2008 23:03:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com> <200802262341.55675.mb@bu3sch.de>
In-Reply-To: <200802262341.55675.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802282303.42676.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 23:41:55 Michael Buesch wrote:
> On Tuesday 26 February 2008 23:12:32 Alexey Zaytsev wrote:
> > >  Yeah, seems so. But if you are willing to test an adjusted version, I can
> > >  probably do a backported version of this patch.
> > >  This patch is well tested and does the right thing, so I'm willing to sign
> > >  off a backported version of this.
> > >  First need to find the place in the old phy.c code that matches the new wa.c code.
> > >
> > I'll do the testing.
> 
> Index: linux-2.6.24.3/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- linux-2.6.24.3.orig/drivers/net/wireless/b43/dma.c	2008-02-26 23:39:39.000000000 +0100
> +++ linux-2.6.24.3/drivers/net/wireless/b43/dma.c	2008-02-26 23:39:43.000000000 +0100
> @@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct 
>  	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
>  	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
[snip]

So are you actually going to do this anytime soon?

-- 
Greetings Michael.
