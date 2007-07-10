Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbXGJO6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbXGJO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbXGJO6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:58:30 -0400
Received: from gw.goop.org ([64.81.55.164]:58181 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbXGJO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:58:29 -0400
Message-ID: <46939E5E.6010305@goop.org>
Date: Tue, 10 Jul 2007 07:57:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
CC: Al Boldi <a1426z@gawab.com>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>	<4691BC0F.8050909@yahoo.com.au> <20070709135205.GB3216@elf.ucw.cz>	<200707091830.48074.a1426z@gawab.com> <87hcoduh4k.fsf@jbms.ath.cx>
In-Reply-To: <87hcoduh4k.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
> I don't know a whole lot about xen, but it seems that one issue with
> this approach is that it requires you run your system under a hypervisor
> at all times, which may introduce some overhead.
>   

No, I don't think that's what Al is proposing.  The kernel-internal 
interfaces we've put in place to make Xen work could be reused to do 
some of the things you're talking about.  In particular, a kernel 
running under Xen has to be able to deal with non-contiguous physical 
pages, and reusing the same pagetable hooks would allow a kexeced kernel 
to run happily out of any random assortment of pages you manage to 
allocate for it.

    J
