Return-Path: <linux-kernel-owner+w=401wt.eu-S934292AbXGKXFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292AbXGKXFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbXGKXFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:05:02 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56659 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbXGKXFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:05:00 -0400
Date: Wed, 11 Jul 2007 16:03:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711230337.GC4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184194219.12353.170.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> The HPET change, which is the larger part of the conversion set simply
> because we now share the code with i386, might be split out by disabling
> HPET in the first step, doing the PIT / APIC conversion and then the
> HPET one in a separate step.

The timer specific changes (i.e. the merges between arches) can be
done more slowly, but the setup above is basically where I started,
and it was already broken on one of my test boxes.  Anyway, I'll help
you however I can, because it's important to me to get this merged.

thanks,
-chris
