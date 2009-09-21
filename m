Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZIURBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZIURBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZIURBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:01:42 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47690 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZIURBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MM8rQx9qPCh780Vqrxi8pPd/0IHLgjtakmK/8t2zsm2rAzOZxO8mGKdLcwhiZ87ZkN
         fEvhqr4YZZaKSQ6g3BXOt1U0pMxQKCo/1XBwYWx1XonLMmHLba1zjMXiCTRmnIkqkHdj
         uUyXE3PO/KmBineZ+Fen94m4TE1nAMu3C6AaU=
Date: Mon, 21 Sep 2009 09:55:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-input@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH v2] input/keyboard: add ADP5588
	QWERTY I2C Keyboard Input device driver
Message-ID: <20090921165517.GA5260@core.coreip.homeip.net>
References: <20090915062050.GB10232@core.coreip.homeip.net> <1253062178-18196-1-git-send-email-vapier@gentoo.org> <20090916050236.GF2756@core.coreip.homeip.net> <8bd0f97a0909210945s5e3d9613pa7a72271ec6b47bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0909210945s5e3d9613pa7a72271ec6b47bc@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 12:45:02PM -0400, Mike Frysinger wrote:
> On Wed, Sep 16, 2009 at 01:02, Dmitry Torokhov wrote:
> > On Tue, Sep 15, 2009 at 08:49:38PM -0400, Mike Frysinger wrote:
> >> From: Michael Hennerich <michael.hennerich@analog.com>
> >>
> >> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> >> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> >> ---
> >> v2
> >>       - merge my and Dmitry's clean up fixes
> >>
> >
> > Looks good, I'd also like to add this instead of recalcularing delay
> > every time:
> 
> this should continue to work fine with cpu scaling right ?

Jiffy value depends only on HZ, not on current cpu frequency so should
be OK I think.

-- 
Dmitry
