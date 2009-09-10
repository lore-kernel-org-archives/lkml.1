Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZIJENv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZIJENv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZIJENu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:13:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZIJENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:13:48 -0400
Date: Thu, 10 Sep 2009 01:13:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090910011320.3a6ec797@caramujo.chehab.org>
In-Reply-To: <4AA73309.8030302@zytor.com>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 08 Sep 2009 21:46:01 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

> Actually it's [7:4][*:8][3:0].  It was the easiest way to get backwards
> compatibility, since it allowed for the use of s[n]printf().  It's not
> by any means the only possibility, but I think the easiest one to describe.
> 
> > From one side, I liked the idea of not having any arbitrary maximum limit, but
> > from other side, It seems easier to implement than to describe it in English,
> > at devices.txt. Maybe the solution is to explain it by examples.
> > 
> > Also, if we look at the current device designation, we already have some rule
> > changes. 
> 
> That doesn't mean it's a good idea.

True. Given the idea of using an unique algorithm to populate the namespace, I agree
that your proposal is a good alternative.

I just sent the patch with the feedbacks I had. I tried to do my best to describe it in
simple yet precise terms at devices.txt.

Thanks,
Mauro
