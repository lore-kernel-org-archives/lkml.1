Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZGTJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZGTJ7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZGTJ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 05:59:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:33338 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbZGTJ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 05:59:48 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090720080502.GG7298@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop>
	 <20090720080502.GG7298@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 19:59:21 +1000
Message-Id: <1248083961.30899.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 10:05 +0200, Nick Piggin wrote:
> 
> Unless anybody has other preferences, just send it straight to Linus in
> the next merge window -- if any conflicts did come up anyway they would
> be trivial. You could just check against linux-next before doing so, and
> should see if it is going to cause problems for any arch pull...

Well, the problem is that powerpc-next will need that patch, which means
that if I don't put it in my tree, Steven won't be able to build
powerpc-next as part of linux-next until the patch is merged. Hence my
question, what's the best way to handle that :-) There isn't an mm-next
is there ? If there was, I could tell Steven to always pull powerpc
after mm for example. Or I can put it in a git tree of its own with a
dependency for Steven to pull.

Cheers,
Ben.

