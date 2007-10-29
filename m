Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXJ2V63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXJ2V63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXJ2V6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:58:19 -0400
Received: from smtp.aaisp.net.uk ([81.187.81.51]:44629 "EHLO smtp.aaisp.net.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXJ2V6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:58:18 -0400
Subject: Re: [stable] 2.6.23 boot failures on x86-64.
From: Martin Ebourne <martin@zepler.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
References: <20071029175014.GH7793@redhat.com>
	 <20071029180739.GA17595@kroah.com>
	 <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 20:27:31 +0000
Message-Id: <1193689651.3133.3.camel@avenin.ebourne.me.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 11:37 -0700, Linus Torvalds wrote:
> Martin - it would be great if you could try out your failing machine with 
> 2.6.24-rc1 (or a nightly snapshot or current git.. the more recent the 
> better).
> 
> But if I'm right, that commit should be reverted from 2.6.24 just because 
> it's pointless (even if the bug itself is gone). And if I'm wrong, it 
> should be reverted. So something like the appended would make sense 
> regardless.
> 
> Can I get a "tested-by"? And/or ack/nack's on my half-arsed theory above?

Current git boots ok as is.

I used the config from the fedora 2.6.23 kernel and accepted defaults
for all the new options.

Cheers,

Martin.

