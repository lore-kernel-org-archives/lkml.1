Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbXF2VWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbXF2VWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbXF2VWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:22:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40363 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbXF2VWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:22:09 -0400
Subject: Re: 2.6.22-rc6 spurious hangs
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Sattler <tsattler@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>
In-Reply-To: <20070629135848.GA332@tv-sign.ru>
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru>
	 <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru>
	 <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de>
	 <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de>
	 <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu>
	 <20070629135848.GA332@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 18:21:30 -0300
Message-Id: <1183152090.7089.183.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Still we can't do this under cinergyt2->sem, because cinergyt2_query()
> takes it too. This all looks very wrong to me, I hope maintaners can
> explain.

AFAIK, the driver authors are not working anymore with CinergyT2. The
last patch we have on development tree from Holger is dated as Dec, 3
2004. Since them, only internal kernel API changes and a few sparse
fixes from other contributors were applied.

Also, none of the current DVB maintainers seem to have any hardware for
testing.


Cheers,
Mauro

