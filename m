Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXFAXah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXFAXah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXFAXab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:30:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:39116 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbXFAXaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:30:30 -0400
Subject: Re: 2.6.22-rc3-mm1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Arnd Bergmann <arndb@de.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20070601140211.81e5c301.akpm@linux-foundation.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	 <200705312243.18724.m.kozlowski@tuxland.pl>
	 <20070531141943.5c4d587c.akpm@linux-foundation.org>
	 <200706012250.58962.m.kozlowski@tuxland.pl>
	 <20070601140211.81e5c301.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 02 Jun 2007 09:30:12 +1000
Message-Id: <1180740612.19517.483.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 14:02 -0700, Andrew Morton wrote:
> 
> 
> Yeah, allmodconfig tends to fall over in a heap on a lot of the
> less-lavishly-maintained architectures.  If any of these are specific
> to
> -mm then I guess we should fix them up, prevent the kernel from
> actually
> going backwards.

Some of the later seems to be related to the lack of CONFIG_PM .. it's
not much a lavish maintainership issue than the fact that nobody every
builds the powermac drivers without CONFIG_PM :-) I'll look into fixing
some of these.

As for the ps3 bits, it's a known problem, the ps3 support is still very
much a work in progress.

Cheers,
Ben.


