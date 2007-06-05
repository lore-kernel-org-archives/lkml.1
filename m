Return-Path: <linux-kernel-owner+w=401wt.eu-S1764929AbXFEOZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764929AbXFEOZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762931AbXFEOZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:25:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761140AbXFEOZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:25:21 -0400
From: Andi Kleen <ak@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
Date: Tue, 5 Jun 2007 16:24:52 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
References: <20070522223828.GV11115@waste.org> <200706051201.32137.ak@suse.de> <1181049060.14054.30.camel@localhost.localdomain>
In-Reply-To: <1181049060.14054.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051624.53157.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 15:11, Rusty Russell wrote:
> On Tue, 2007-06-05 at 12:01 +0200, Andi Kleen wrote:
> > > But TSC is a "required feature", so "cpu_has_tsc" is always true.
> >
> > Hmm? It isn't. What makes you think so?
>
> Interestingly it seems to be only in -mm.

If it is then it doesn't come out of my tree. Also sounds broken to me.
The required bits are only for features needed by the compiler's generated
code where not having them could cause an early crash.

-Andi
