Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbXIJRoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbXIJRoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbXIJRoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:44:03 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3205 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbXIJRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:44:00 -0400
Date: Mon, 10 Sep 2007 18:43:34 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mel@csn.ul.ie
Subject: Re: 2.6.23-rc4-mm1 -- powerpc per_cpu__cpu_sibling_map compile failure
Message-ID: <20070910174334.GB30335@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am seeing the following compile error on all of my powerpc platforms:

  CC      kernel/sched.o
  kernel/sched.c: In function `cpu_to_phys_group':
  kernel/sched.c:5937: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)
  kernel/sched.c:5937: error: (Each undeclared identifier is reported only once
  kernel/sched.c:5937: error: for each function it appears in.)
  kernel/sched.c:5937: warning: type defaults to `int' in declaration of `type name'
  kernel/sched.c:5937: error: invalid type argument of `unary *'
  kernel/sched.c: In function `build_sched_domains':
  kernel/sched.c:6172: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)
  kernel/sched.c:6172: warning: type defaults to `int' in declaration of `type name'
  kernel/sched.c:6172: error: invalid type argument of `unary *'
  kernel/sched.c:6183: warning: type defaults to `int' in declaration of `type name'
  kernel/sched.c:6183: error: invalid type argument of `unary *'
  make[1]: *** [kernel/sched.o] Error 1
  make: *** [kernel] Error 2

-apw
