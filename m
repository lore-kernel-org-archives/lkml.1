Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXHCTAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXHCTAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbXHCS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:59:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbXHCS75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:59:57 -0400
Date: Fri, 3 Aug 2007 20:59:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about modularization
Message-ID: <20070803185954.GB20580@elte.hu>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com> <20070803131900.GA26203@elte.hu> <46B36A43.6030101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B36A43.6030101@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> On 08/03/2007 03:19 PM, Ingo Molnar wrote:
> 
> > One of the authors of the IO scheduler code said it on lkml recently 
> > that while modularization of IO scheduler had advantages too, in 
> > retrospect he wishes they would not have made IO schedulers modular 
> > and now that decision cannot be undone.
> 
> Just as a matter of interest -- why can't it? (a pointer to a list 
> archive if you have one, or a name so I can look for it myself if you 
> don't, will do as answer).

some apps depend on AS, some on CFQ, and once you expose something to 
users it's _very_ hard to remove it, even if the technical arguments are 
strong.

  http://lists.openwall.net/linux-kernel/2007/04/16/23

	Ingo
