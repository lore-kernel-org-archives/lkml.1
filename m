Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXI1Of1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXI1Of1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbXI1OfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:35:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257AbXI1OfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:35:13 -0400
Date: Fri, 28 Sep 2007 07:34:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
In-Reply-To: <200709280740.40163.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org>
References: <20070918080537.GA14882@devil> <20070919233110.18a057ac.akpm@linux-foundation.org>
 <200709280740.40163.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Sep 2007, Nick Piggin wrote:
> >
> > God I hate select.
> 
> IMO a better implementation would result in a notification / confirmation of
> turning on new items, and the ability to deselect options which will also
> confirm to deselect dependants. Like most other systems that have similar
> problem to solve.

Actually, the *really* nice thing to do would be to just add the reason 
something got enabled into the ".config" file.

IOW, wouldn't it be nice if the .config file just said

	...
	CONFIG_ACPI=y		# selected by X86_64_ACPI_NUMA
	CONFIG_ACPI_PROCFS=y	# user choice
	...

etc, since the config process actually does know these things?

That way, there's always a fairly straightforward way to see why some 
configuration is the way it is (and the .config file is not only useful 
for "make oldconfig", it's also what normally gets passed around for bug 
reports, and is part of distro kernel packages etc, so it would seem to be 
the right place, no?)

		Linus
