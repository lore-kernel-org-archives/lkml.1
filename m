Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYKQXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYKQXRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:17:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:58471 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbYKQXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:17:30 -0500
Subject: Re: Large stack usage in fs code (especially for PPC64)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org
In-Reply-To: <20081117133137.616cf287.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	 <20081117130856.92e41cd3.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0811171320330.18283@nehalem.linux-foundation.org>
	 <20081117133137.616cf287.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 10:17:04 +1100
Message-Id: <1226963824.7178.255.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'd have thought so, but I'm sure we're about to hear how important an
> optimisation the smaller stacks are ;)

Not sure, I tend to agree that it would make sense to bump our stack to
64K on 64K pages, it's not like we are saving anything and we are
probably adding overhead in alloc/dealloc. I'll see what Paul thinks
here.

> Yup.  That being said, the younger me did assert that "this is a neater
> implementation anyway".  If we can implement those loops without
> needing those on-stack temporary arrays then things probably are better
> overall.

Amen.

Cheers,
Ben.


