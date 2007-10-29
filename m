Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXJ2STB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXJ2STB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXJ2SSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:18:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:56061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbXJ2SSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:18:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.23 boot failures on x86-64.
Date: Mon, 29 Oct 2007 19:18:43 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071029175014.GH7793@redhat.com>
In-Reply-To: <20071029175014.GH7793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291918.43869.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 18:50:14 Dave Jones wrote:
> We've had a number of people reporting that their x86-64s stopped booting
> when they moved to 2.6.23.  It rebooted just after discovering the AGP bridge
> as a result of the IOMMU init.

It's probably the usual "nobody tests sparsemem at all" issue.

But if allocating bootmem >4G doesn't work on these systems
most likely they have more problems anyways. It might be better
to find out what goes wrong exactly.

-Andi
