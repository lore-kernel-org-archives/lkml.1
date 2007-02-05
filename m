Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXBEI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXBEI1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 03:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXBEI1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 03:27:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:42203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXBEI1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 03:27:18 -0500
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.20-rc7: known regressions
Date: Mon, 5 Feb 2007 09:26:50 +0100
User-Agent: KMail/1.9.5
Cc: =?iso-8859-15?q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <1170594788.5217.4.camel@funkylaptop> <Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702040928330.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200702050926.51007.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 February 2007 18:34, Linus Torvalds wrote:
> 
> On Sun, 4 Feb 2007, Frédéric Riss wrote:
> > 
> > New patch:
> 
> I didn't get how this would fix the ia64 issues? I thought ia64 needed 
> the standard calling convention?

asmlinkage is standard enough on ia64 as far as I can see.

It defines to an undocumented attribute that seems to only affect the
generated code for functions (basically it forces the compiler
to not reuse input arguments, similar to prevent_tail_call() on i386), 
not for pointers.

-Andi
