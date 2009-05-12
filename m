Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZELKPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZELKPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZELKPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:15:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZELKPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:15:36 -0400
Date: Tue, 12 May 2009 12:15:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512101514.GA7915@elte.hu>
References: <20090511222702.352192505@arndb.de> <200905112319.17999.arnd@arndb.de> <20090512075513.GA14122@elte.hu> <200905121104.31275.arnd@arndb.de> <20090512091010.GD18004@elte.hu> <20090512102105.291afe53@lxorguk.ukuu.org.uk> <20090512092601.GB29796@elte.hu> <20090512110527.5352cd0e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512110527.5352cd0e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > My argument was very simple: the patch causes +150 bytes of 
> > bloat. The try/ex/catch method can help reduce register pressure 
> > and can reducethe size of code quite visibly.
> 
> My argument is even simpler - its not worth the effort in the 
> first place.
> 
> I'm sure you could use the same time to shave 150 bytes and a few 
> clocks of a path that actually gets executed.

This is about kernel image size as well. This version of the patch 
bloats the kernel. The death of a thousand cuts ...

> Arnd - can you send me a diff that keeps the existing horrible 
> macro version, the existing __put_user usage and just fixes c_line 
> ? It's worked for 15 years, its not worth the time being fancy 
> with it.

Agreed.

	Ingo
