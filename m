Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbYAGVdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbYAGVdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYAGVd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:33:26 -0500
Received: from rtr.ca ([76.10.145.34]:2300 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbYAGVdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:33:25 -0500
Message-ID: <47829AA7.3020304@rtr.ca>
Date: Mon, 07 Jan 2008 16:33:27 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, abelay@novell.com,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <20071130142058.816d1693.akpm@linux-foundation.org> <20080106231848.762e93c1.akpm@linux-foundation.org> <4782400D.2040802@rtr.ca> <200801071412.59964.lenb@kernel.org>
In-Reply-To: <200801071412.59964.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> 1. Why does VMware need max_cstate=1 to load quickly?
..

Eh?  Nothing to do with "loading" anything,
but rather it's simple responsiveness to guest keyboard
input that we're experiencing trouble with.
The guest OS is probably "broken" in that regard,
but setting max_cstate=1 makes it usable here.

> 2. Why does the "max_csate=1" workaround help only
>    on the dual-core boxes, while the single-core
>    boxes still fail to load quickly?
..

Eh?  Setting max_cstate=1 helps on both single/dual core
boxes/kernels here.  The alternative (newer) latency thing
(that requires a custom kernel module to change on the fly)
is the thing that had no effect at all on our single-core box,
but did seem to help the dual-core more (not verified completely
on dual-core though).

Cheers
