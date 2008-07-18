Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYGRNIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYGRNIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYGRNIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:08:40 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:56303 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYGRNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:08:39 -0400
Date: Fri, 18 Jul 2008 15:07:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs 	(part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080718130754.GB32051@basil.nowhere.org>
References: <1216146802.3312.95.camel@localhost.localdomain> <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins> <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Jul 2008 13:07:52.0689 (UTC) FILETIME=[4962E610:01C8E8D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For example, we're about to do unwinding/stack-traces of userspace
> programs.  To what extent do you think the kernel unwinder (should one
> reappear in git) would welcome patches that provide zero benefit to
> the kernel, but only enable a peculiar (nonintrusive) sort of
> unwinding we would need for complex userspace stacks?

In theory if the tables are right you don't need any special
for the kernel dwarf2 unwinder.  If the tables are not right
fix them.

I believe oprofile did this already in some cases (generating
user back traces from the kernel) 

-Andi
