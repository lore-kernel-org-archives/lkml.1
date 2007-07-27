Return-Path: <linux-kernel-owner+w=401wt.eu-S937408AbXG0Ro4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937408AbXG0Ro4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760705AbXG0Ror
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:44:47 -0400
Received: from khc.piap.pl ([195.187.100.11]:51747 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbXG0Roq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:44:46 -0400
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	<m3abtir95x.fsf@maximus.localdomain>
	<20070726173501.9ba466ba.akpm@linux-foundation.org>
	<m3bqdx6dlq.fsf@maximus.localdomain>
	<1185555916.2642.8.camel@josh-work.beaverton.ibm.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 27 Jul 2007 19:44:41 +0200
In-Reply-To: <1185555916.2642.8.camel@josh-work.beaverton.ibm.com> (Josh Triplett's message of "Fri, 27 Jul 2007 10:05:16 -0700")
Message-ID: <m3r6mt4u7q.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josht@linux.vnet.ibm.com> writes:

> Perhaps, but
>      1. Existing kernel style uses braces with single-statement
>         do-while.
>      2. Linus prefers (or at least preferred in October of 2006) braces
>         with single-statement do-while.

Fine with me, but it should IMHO be maintainer's call.

Things which a) are clearly better, and/or b) would require massive
reformatting when new maintainer steps in, should be documented
in CodingStyle and perhaps checked for by scripts and sparse.

Other things... sometimes there are multiple ways to do something
well, and humans aren't, and shouldn't be that deterministic.
-- 
Krzysztof Halasa
