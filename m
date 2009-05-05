Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZEEOOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZEEOOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZEEOOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:14:30 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:52250 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751539AbZEEOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:14:29 -0400
Date: Tue, 5 May 2009 16:14:27 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
cc: linux-crypto@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] crypto: compress - Return produced bytes in crypto_{,
 de}compress_{update, final}() (was: Re: [PATCH/RFC] crypto: compress - Add
 comp_request.total_out (was: Re: [PATCH 6/6] squashfs: Make SquashFS 4 use
 the new pcomp crypto interface))
In-Reply-To: <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
 <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Geert Uytterhoeven wrote:
> On Mon, 20 Apr 2009, Herbert Xu wrote:
> > On Tue, Mar 24, 2009 at 05:33:01PM +0100, Geert Uytterhoeven wrote:
> > > Here's an alternative patch, which does exactly that.
> > > Phillip, what do you think?
> > > 
> > > Thanks for your comments!
> > > 
> > > >From be7d630f96a85d3ce48716b8e328563ba217647b Mon Sep 17 00:00:00 2001
> > > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > > Date: Tue, 24 Mar 2009 17:19:05 +0100
> > > Subject: [PATCH] crypto: compress - Return produced bytes in crypto_{,de}compress_{update,final}()
> > > 
> > > If crypto_{,de}compress_{update,final}() succeed, return the actual number of
> > > bytes produced instead of zero, so their users don't have to calculate that
> > > theirselves.
> > > 
> > > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > 
> > I certainly prefer this version over the other one? Do you want to
> > submit crypto API portion of this?
> 
> If you think I should submit it now, I can do it. But I'm still waiting for
> Phillip's comments.

Phillip, any progress?

If we want to change the API of crypto_{,de}compress_{update,final}(), we
should do it before the release of 2.6.30, and we're already at -rc4...

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
