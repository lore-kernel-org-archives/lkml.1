Return-Path: <linux-kernel-owner+w=401wt.eu-S1161257AbXECIGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257AbXECIGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161534AbXECIGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:06:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161257AbXECIGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:06:39 -0400
Date: Thu, 3 May 2007 01:05:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: incoming
Message-Id: <20070503010535.b18a49d6.akpm@linux-foundation.org>
In-Reply-To: <20070503075543.GA12018@flint.arm.linux.org.uk>
References: <20070502150252.7ddf67ac.akpm@linux-foundation.org>
	<20070503075543.GA12018@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 08:55:43 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Wed, May 02, 2007 at 03:02:52PM -0700, Andrew Morton wrote:
> > So this is what I have lined up for the first mm->2.6.22 batch.  I won't be
> > sending it off for another 12-24 hours yet.  To give people time for final
> > comment and to give me time to see if it actually works.
> 
> I assume you're going to update this list with my comments I sent
> yesterday?
> 

Serial drivers?  Well you saw me drop a bunch of them.  I now have:

serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
serial-define-fixed_port-flag-for-serial_core.patch
mpsc-serial-driver-tx-locking.patch
serial-serial_core-use-pr_debug.patch

I'll also be holding off on MADV_FREE - Nick has some performance things to
share and I'm assuming they're not as good as he'd like.

