Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbXGJHBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbXGJHBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbXGJHAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:00:54 -0400
Received: from ozlabs.org ([203.10.76.45]:37710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbXGJHAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:00:53 -0400
Subject: Re: maps2-add-proc-pid-pagemap-interface.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070710062736.GF11115@waste.org>
References: <1183894381.6005.324.camel@localhost.localdomain>
	 <20070709223101.GW11115@waste.org>
	 <1184041730.6005.480.camel@localhost.localdomain>
	 <20070710062736.GF11115@waste.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 17:00:35 +1000
Message-Id: <1184050835.6005.532.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 01:27 -0500, Matt Mackall wrote:
> On Tue, Jul 10, 2007 at 02:28:50PM +1000, Rusty Russell wrote:
> > I don't think normal ptraces get cut on exec, so I'm not sure why this
> > should be different.
> 
> They absolutely do, if UID changes. Consider ptracing a shell
> launching a setuid binary.

No, ptraced processes don't change uid on execing a setuid binary.
Which works, but isn't what you want 8(

> For something more closely analogous, consider opening /proc/pid/mem
> on the same shell...

Ah, now I see where you got this from.  OK, but can I have a comment
please?

Thanks!
Rusty.

