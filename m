Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXJ0ObX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXJ0ObX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJ0ObQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:31:16 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1818 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbXJ0ObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:31:16 -0400
Date: Sat, 27 Oct 2007 15:30:29 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, tglx@linutronix.de,
       nickpiggin@yahoo.com.au, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] bitops kernel-doc: inline instead of macro
Message-ID: <20071027143029.GC5529@shadowen.org>
References: <20071023220959.a359d57d.rdunlap@xenotime.net> <200710241800.19764.nickpiggin@yahoo.com.au> <20071025093159.3ea69d03.rdunlap@xenotime.net> <alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain> <20071025095540.827d4333.rdunlap@xenotime.net> <20071025134814.caced2e3.akpm@linux-foundation.org> <20071027104328.GA5529@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027104328.GA5529@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 11:43:28AM +0100, Andy Whitcroft wrote:
> On Thu, Oct 25, 2007 at 01:48:14PM -0700, Andrew Morton wrote:
> 
> > Andy, I thought we were going to whine about __inline__ and __inline, too?
> 
> Hmmm, I don't remember that coming up, but I'll add it to the todo.  I
> am assuming plain 'inline' is preferred over both of these -- yell if
> you meant something else.

Ok, this will be in the next release and is in -next.

	WARNING: plain inline is preferred over __inline
	#4: FILE: tmp/testset-28768.c:1:
	+static __inline int foo(void)

-apw
