Return-Path: <linux-kernel-owner+w=401wt.eu-S1946424AbXBCJ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946424AbXBCJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946425AbXBCJ6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:58:24 -0500
Received: from mx1.suse.de ([195.135.220.2]:46150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946424AbXBCJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:58:24 -0500
From: Andi Kleen <ak@suse.de>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric_Riss?= <frederic.riss@gmail.com>
Subject: Re: 2.6.20-rc7: known regressions
Date: Sat, 3 Feb 2007 10:58:13 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702031033.42940.ak@suse.de> <1170496175.31373.31.camel@funkylaptop>
In-Reply-To: <1170496175.31373.31.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200702031058.13830.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 February 2007 10:49, Frédéric Riss wrote:

> Was what I did in the initial patch: 
>      http://lkml.org/lkml/2007/1/30/258 
> 
> The issue is that the structure definition is used on multiple
> architectures (for now ia64 and i386) which might used different calling
> conventions. As Bjorn Helgaas pointed out, ia64 already has such wrapper
> functions. I agree that the casting isn't the nicest thing, but I prefer
> that to writing asm stubs.

Define a efilinkage macro then that expands to nothing on ia64

Probably asmlinkage would work already, syscall_linkage as used on ia64 doesn't
seem to affect function pointers.

-Andi
