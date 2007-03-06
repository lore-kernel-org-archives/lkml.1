Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXCFRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXCFRSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXCFRSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:18:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXCFRSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:18:41 -0500
Date: Tue, 6 Mar 2007 18:18:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306171813.GA21218@elte.hu>
References: <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2F53.2040101@goop.org> <20070306092636.GC26073@elte.hu> <45ED99F8.9060705@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED99F8.9060705@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > My suggestion would be for Linux to make only a /single/ external 
> > ABI promise: VMI. (and we can extend it with higher-level paravirt 
> > ops, etc.)
> 
> "VMI" is not a promise, it's just three letters.  It doesn't even mean 
> the same thing now as it did 12 months ago.  Turning "VMI" from three 
> letters into anything remotely like a promise is a huge amount of work 
> which requires:
> 
>    1. someone actually sit down and fully document what all those
>       entrypoints are going to do
>    2. everyone to implement them
>    3. someone to test that all the implementations conform to the
>       document (bearing in mind that if anyone is going to go to all
>       this effort, they're going to use this with non-Linux guests)
>    4. and repeat all that every subsequent update

There's no process needed. The only thing needed is to treat the Linux 
implementation as the reference design, documentation and specification. 
Treat it as we treat the Linux system calls. We promise not to change 
them. There's no "process" for that either, other than our promise, our 
taste and our best efforts - plus the backing of all distributions and 
the threat of a few million users who start yelling (or worse) if we 
break it ;)

	Ingo
