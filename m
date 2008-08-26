Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYHZLz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYHZLz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYHZLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:55:11 -0400
Received: from ozlabs.org ([203.10.76.45]:45557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYHZLzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:55:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Tue, 26 Aug 2008 11:11:18 +1000
User-Agent: KMail/1.9.9
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261111.19205.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 06:43:03 Linus Torvalds wrote:
> So now load_module() will still use almost 500 bytes of stack

Hmm, wants neatening anyway; I'll see if I can reduce stack usage side effect.

Your workaround is very random, and that scares me.  I think a huge number of 
CPUs needs a real solution (an actual cpumask allocator, then do something 
clever if we come across an actual fastpath).

Thanks,
Rusty.
