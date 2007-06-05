Return-Path: <linux-kernel-owner+w=401wt.eu-S1764620AbXFEOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764620AbXFEOG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762155AbXFEOGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:06:52 -0400
Received: from waste.org ([66.93.16.53]:39243 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760512AbXFEOGv (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:06:51 -0400
Date: Tue, 5 Jun 2007 09:06:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605140635.GS11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070605092344.GA20600@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605092344.GA20600@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:23:44AM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > Ok, my transcoding just finished as I was writing this. So I've 
> > reproduced the problem with this Python script that I had handy:
> > 
> > memload.py:
> > #!/usr/bin/python
> > a = "a" * 16 * 1024 * 1024
> > while 1:
> >     b = a[1:] + "b"
> >     a = b[1:] + "c"
> 
> i suspect the same latency is triggered by a simple infinite loop too:
> 
> 	while : ; do : ; done &
> 
> correct?

Yes.

-- 
Mathematics is the supreme nostalgia of our time.
