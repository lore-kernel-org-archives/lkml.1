Return-Path: <linux-kernel-owner+w=401wt.eu-S936846AbXG0RFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936846AbXG0RFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbXG0RE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:04:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39604 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929AbXG0REx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:04:53 -0400
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
In-Reply-To: <m3bqdx6dlq.fsf@maximus.localdomain>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	 <m3abtir95x.fsf@maximus.localdomain>
	 <20070726173501.9ba466ba.akpm@linux-foundation.org>
	 <m3bqdx6dlq.fsf@maximus.localdomain>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 10:05:16 -0700
Message-Id: <1185555916.2642.8.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 18:00 +0200, Krzysztof Halasa wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > it's better that we all do things the same way.  What that way _is_ is
> > actually less important, unless it's something stupid, of course.
> 
> It's certainly true WRT things like indentation but IMHO it shouldn't
> go that far, and if it goes, it should be non-braced version.
> 
> If we prefer non-braced versions of "if" and "while", it would be
> a bit strange to require braces with "do while", wouldn't it?

Perhaps, but
     1. Existing kernel style uses braces with single-statement
        do-while.
     2. Linus prefers (or at least preferred in October of 2006) braces
        with single-statement do-while.

> Sparse warnings... I think it shouldn't complain either, unless
> called with extra parameter.

Good point; Sparse shouldn't warn about this by default.  I've turned
that off in latest Sparse from Git, so you need to give -Wdo-while or
-Wall to get warnings about that.  However, the kernel gives -Wall, so
you'll still see the warnings there.

- Josh Triplett


