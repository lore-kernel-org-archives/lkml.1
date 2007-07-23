Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbXGWQWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbXGWQWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbXGWQWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:22:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759199AbXGWQWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:22:15 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__ II
Date: Mon, 23 Jul 2007 18:22:11 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in> <200707231818.00547.ak@suse.de>
In-Reply-To: <200707231818.00547.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231822.11734.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


BTW if you want to optimize inline asm code a bit -- find_first_bit / 
find_first_zero_bit / for_each_cpu could really benefit from a optimized version 
for cpumask_t sized bitmaps. That would  save a lot of cycles in some of the 
hotter paths of the kernel like the scheduler.

-Andi
