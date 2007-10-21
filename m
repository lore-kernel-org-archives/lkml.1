Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbXJUVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbXJUVLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXJUVLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:11:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:52483 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXJUVLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:11:05 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192769910.7367.106.camel@pasglop>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
	 <20071019023219.GB8453@gondor.apana.org.au>
	 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
	 <20071019042025.GA9617@gondor.apana.org.au>
	 <20071019044806.GA10080@gondor.apana.org.au>
	 <1192769910.7367.106.camel@pasglop>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 07:10:05 +1000
Message-Id: <1193001005.6745.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 .../...

> This patch (mostly written by Linus) fixes this by using spin
> > locks instead of memory barries on the synchronize_irq() path.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Good for me.
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Hrm... not on yet. Herbert, care to resend, looks like it fell down the
wrong hole in Linus mailbox :-)

Cheers,
Ben.


