Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbXERSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbXERSWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXERSWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:22:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55351 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXERSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:22:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
References: <20070517230324.GB8089@linux-os.sc.intel.com>
	<m1ejlf0y96.fsf@ebiederm.dsl.xmission.com>
	<20070518010119.GB12088@linux-os.sc.intel.com>
	<m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
	<86802c440705181030m6d72edf6w87749275c46c7c93@mail.gmail.com>
	<m1abw2105a.fsf@ebiederm.dsl.xmission.com>
	<86802c440705181109h458232a1rd85f3794cffa3ff1@mail.gmail.com>
Date: Fri, 18 May 2007 12:20:02 -0600
In-Reply-To: <86802c440705181109h458232a1rd85f3794cffa3ff1@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 18 May 2007 11:09:25 -0700")
Message-ID: <m11whe0zal.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 5/18/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> We can solve the problem without doing that, and keeping the same
>> vector number during migration keeps x86 from scaling.
>
> I mean ioapic level irq couls be limited. new device could use MSI or
> HT irq directly and less irq routing problem.

Possibly.  It really doesn't buy us anything until most irqs are MSI
which they are not yet.

>> Personally I would prefer to disallow irq migration.
> ? typo?
> For amd platform with different hypertransport chain on different
> nodes, irq migration is needed.

irqs not on cpu0 are needed.  irq migration is less necessary, and I periodically
think we are insane for supporting it.

Eric
