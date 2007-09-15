Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXIOUB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXIOUB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 16:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXIOUBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 16:01:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXIOUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 16:01:20 -0400
Date: Sat, 15 Sep 2007 22:01:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: x86_64: Remove unnecessary cast in prefetch()
Message-ID: <20070915200117.GC14501@one.firstfloor.org>
References: <87tzq7cwnt.fsf@depni.sinp.msu.ru> <200709070818.03995.ak@suse.de> <878x78ig85.fsf@depni.sinp.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878x78ig85.fsf@depni.sinp.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 10:40:26AM +0400, Serge Belyshev wrote:
> Andi Kleen <ak@suse.de> writes:
> 
> >> This can be fixed better by using gcc's __builtin_prefetch().
> >
> > I changed it to just use that. Thanks.
> >
> > It seems like gcc 3.1/3.2 already supported it and that's the earliest gcc
> > still supported so it can be used unconditionally.
> >
> 
> Hi!
> 
> Will you submit this patch for inclusion into 2.6.23?  It is important

Didn't plan it currently.

> to make kernel work with GCC 4.3 and above.  (Also note that gcc 4.2 already
> smart enough to break that code, but kernel is just lucky currently).

How would it break the code exactly?  It more sounded like an optimization
to me. Would it generate incorrect code without it?

-Andi
