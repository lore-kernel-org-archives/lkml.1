Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbZKMIMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbZKMIMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZKMIM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:12:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbZKMIM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:12:26 -0500
Date: Fri, 13 Nov 2009 09:12:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
Message-ID: <20091113081205.GC18054@elte.hu>
References: <4AF7D820.5040503@kernel.org>
 <4AFA210B.3020207@kernel.org>
 <20091112073616.GA11365@elf.ucw.cz>
 <200911122032.46872.rjw@sisk.pl>
 <20091113073608.GB26127@elte.hu>
 <4AFD12F2.2090103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD12F2.2090103@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/12/2009 11:36 PM, Ingo Molnar wrote:
> > 
> > Physical constraints to allocations (which this is) should be expressed 
> > early and with high priority, to make sure they can be met.
> > 
> 
> Indeed, and in this case this means before bootmem allocator initialization.

The other advantage of Yinghai's patch is that it removes a bootmem 
usage from x86, which moves us a bit forward on the road to remove the 
bootmem allocator altogether and go from early allocators to slab 
straight away.

	Ingo
