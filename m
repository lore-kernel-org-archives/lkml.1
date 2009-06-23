Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZFWN3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZFWN3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbZFWN3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:29:02 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:53721 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996AbZFWN27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:28:59 -0400
Date: Tue, 23 Jun 2009 18:58:57 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>
Subject: Hardware Breakpoint interfaces for mainline?
Message-ID: <20090623132857.GA4242@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	The hardware breakpoint patches and the ksym tracer (an ftrace
plugin), as you know, are part of the -tip tree.

The patches to use debug registers by the kernel have been pursued since
long (IIRC, since kprobe days) and their recent inclusion in -tip tree
is done after accomodating your suggestions about the breakpoint
infrastructure's design and after introducing an associated use-case in
ftrace (ksym tracer).

The breakpoint interfaces along with ksym tracer can be a fine addition
to the kernel's debugging abilities in a variety of ways such as debugging
memory corruption, data/memory access profiling, etc.

Your recent concerns about a few usability issues and minor bugs in ksym
tracer have been addressed and the relevant patches have been submitted
for inclusion in -tip.

I believe that it is still your plan to submit this feature for mainline
inclusion during this merge window, allowing developers to benefit from
the debug register's abilities in x86 and spur further development of
features on it.

In this context, do you find a concern that still require the patches to
remain in -tip? Or are there plans to submit the hardware breakpoint
patchset for upstream inclusion during this 2.6.31 merge window itself?

Kindly let me know of your plans for this feature.

Thanks,
K.Prasad

