Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbXFENuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbXFENuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXFENty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:49:54 -0400
Received: from waste.org ([66.93.16.53]:41300 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbXFENty (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:49:54 -0400
Date: Tue, 5 Jun 2007 08:49:33 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605134933.GP11115@waste.org>
References: <20070604173710.GR11166@waste.org> <1181002734.25878.56.camel@localhost.localdomain> <1181010675.25878.140.camel@localhost.localdomain> <20070605041803.GO11115@waste.org> <1181018258.25878.150.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181018258.25878.150.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 02:37:38PM +1000, Rusty Russell wrote:
> On Mon, 2007-06-04 at 23:18 -0500, Matt Mackall wrote:
> > On Tue, Jun 05, 2007 at 12:31:15PM +1000, Rusty Russell wrote:
> > > Does this solve it for you?
> > 
> > Nope. Doesn't accept input and hogs the CPU with lots of system time.
> 
> Dumb question: did you replace both the module and the launcher?

Oh, probably not. Yep, actually loading the new module appears to fix it.

-- 
Mathematics is the supreme nostalgia of our time.
