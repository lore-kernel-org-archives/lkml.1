Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXDDQLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXDDQLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXDDQLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:11:03 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35025 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXDDQKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:10:55 -0400
Date: Wed, 4 Apr 2007 18:10:02 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Natalie Protasevich <nataliep@google.com>, Andi Kleen <ak@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       auke-jan.h.kok@intel.com
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <Pine.LNX.4.64.0704031940080.28249@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0704041748330.28249@twin.jikos.cz>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz> <46126EAA.3050000@intel.com>
 <Pine.LNX.4.64.0704031725300.28249@twin.jikos.cz> <46128C92.2020908@intel.com>
 <Pine.LNX.4.64.0704031940080.28249@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Jiri Kosina wrote:

> > we're also having problems reproducing it on that same combination 
> > (2.6.21-rc4 + my tree), so it points to something in -mm. Since your 
> > trace is completely different right now it looks like something else 
> > is fuzzing it up. Since the e1000 changes are in rc5-mm3 as well, that 
> > might help to narrow it down quickly.
> I don't know (yet) whether rc5-mm3 was OK in this respect, I didn't boot 
> it on this machine. I only know that both rc5 and rc5 + e1000 tree are 
> OK, but rc5-mm4 panics on ifconfig/dhclient on e1000 card immediately on 
> my system.
> I will start bisection when I get back to the respective machine 
> (tomorrow) and will let you know.

And the bisection winner is

	i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch

I don't immediately see how it could be causing it, so adding CCs which 
are listed in the patch.

Original description of the symptoms at http://lkml.org/lkml/2007/4/3/90

-- 
Jiri Kosina
