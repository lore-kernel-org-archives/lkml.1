Return-Path: <linux-kernel-owner+w=401wt.eu-S1767501AbXDFCUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767501AbXDFCUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767503AbXDFCUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:20:12 -0400
Received: from ozlabs.org ([203.10.76.45]:40777 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767501AbXDFCUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:20:10 -0400
Subject: Re: [PATCH] Unified lguest launcher
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org
In-Reply-To: <5d6222a80704050743l3c387287kdbe7eb069b793d6e@mail.gmail.com>
References: <5d6222a80704040903n49442679p2a6841de69d894c2@mail.gmail.com>
	 <1175741082.12230.610.camel@localhost.localdomain>
	 <5d6222a80704050743l3c387287kdbe7eb069b793d6e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 12:19:43 +1000
Message-Id: <1175825983.12230.666.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 11:43 -0300, Glauber de Oliveira Costa wrote:
> and here's the new patch, merging rusty's suggestions and some more on my own.
> 
> May I upload this, or does Rusty (or any other) has some more suggestions?

This looks excellent!

There are a couple of extra spaces floating around, but that's trivial.
You use "errno = ESRCH; err()" where you could use "errx()".

Please merge it straight in. No need for a separate patch in the tree
for this I think, unless you plan more work?

Thanks!
Rusty.

