Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYB1Ws6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYB1Ws6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbYB1Wsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:48:50 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:61707 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYB1Wsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DlTC/YdyxBXCgZbSzJ+xSgy21xmOttG3uy65648unAW8I8sgDqEfCplNn/cy9dk4z/0KJuNWfxms+xrGUoPYt7QwE8SypOTZ9vssUbwE8wZIrBzjSnNeYuWBdrutuXWOmY6XGqu7mPCSx2U/cNISwuGRqDTmnM+Z/RUl7P/1nB0=
Message-ID: <f19298770802281448k91e71dh6583db94e1a6f4e7@mail.gmail.com>
Date: Fri, 29 Feb 2008 01:48:48 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802282303.42676.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru>
	 <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
	 <200802262341.55675.mb@bu3sch.de> <200802282303.42676.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 1:03 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 26 February 2008 23:41:55 Michael Buesch wrote:
>  > On Tuesday 26 February 2008 23:12:32 Alexey Zaytsev wrote:
>  > > >  Yeah, seems so. But if you are willing to test an adjusted version, I can
>  > > >  probably do a backported version of this patch.
>  > > >  This patch is well tested and does the right thing, so I'm willing to sign
>  > > >  off a backported version of this.
>  > > >  First need to find the place in the old phy.c code that matches the new wa.c code.
>  > > >
>  > > I'll do the testing.
>  >
>  > Index: linux-2.6.24.3/drivers/net/wireless/b43/dma.c
>  > ===================================================================
>  > --- linux-2.6.24.3.orig/drivers/net/wireless/b43/dma.c        2008-02-26 23:39:39.000000000 +0100
>  > +++ linux-2.6.24.3/drivers/net/wireless/b43/dma.c     2008-02-26 23:39:43.000000000 +0100
>  > @@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct
>  >       addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
>  >       addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
>  [snip]
>
>  So are you actually going to do this anytime soon?
>

Sorry for the delay. Yes, it worked fine.

Btw, when booting the system with the b43 driver, I get a
~30 socond delay after the boot scripts report
"Waiting for /dev to be fully populated" and all the modules
get loaded. Is this something expected?



>  --
>  Greetings Michael.
>
