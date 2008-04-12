Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYDLHE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYDLHE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 03:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYDLHER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 03:04:17 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:16131 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYDLHEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:04:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoBAMP7/0fEAmHEh2dsb2JhbACRUwEBAQoFCQUYmEs
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
Date: Sat, 12 Apr 2008 09:04:11 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <200804112342.48830.bonganilinux@mweb.co.za> <alpine.LFD.1.00.0804111605390.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804111605390.3143@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804120904.11423.bonganilinux@mweb.co.za>
X-Original-Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
X-Scan-Signature: 3304700b570ad40f94459d984b289eda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008 01:12:37 Linus Torvalds wrote:
> On Fri, 11 Apr 2008, Bongani Hlope wrote:
> > After about 4 restarts and 4 reboots, 2.6.25-rc9 seems to work fine with
> > and without the revert. I'll do some more testing.  The assembly output
> > files for kernel/printk.c don't seem that different between rc9 and rc7.
> > I'll see what else I can test.
>
> Ok, I suspect it may be timing-dependent and slightly random.
>

Nope it happens all the time with rc7 and rc8.... 

> Sadly, that is absolutely the case where "git bisect" works the worst. The
> end result of bisection will basically be _totally_ random if even one of
> the "git bisect bad/good" choises were wrong - doing a binary search is
> a very efficient way to find the buggy commit, but it also means that a
> single wrong turn will efficiently find a commit that is somewhere totally
> different.
>

git revert 266c2e0abeca649fa6667a1a427ad1da507c6375 on rc8 makes rc8 work 
again.

