Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZANTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZANTvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZANTvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:51:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZANTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:51:29 -0500
Subject: Re: [GIT PULL] adaptive spinning mutexes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
       andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
In-Reply-To: <20090114113638.c818fcf8.akpm@linux-foundation.org>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114183319.GA18630@elte.hu>
	 <20090114105300.66bd014d.akpm@linux-foundation.org>
	 <20090114190008.GA13203@elte.hu>
	 <20090114113638.c818fcf8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 20:50:50 +0100
Message-Id: <1231962650.14825.55.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 11:36 -0800, Andrew Morton wrote:

> Do people enable CONFIG_SCHED_DEBUG?

Well, I have it always enabled, but I've honestly no idea if that makes
me weird.

> CONFIG_DEBUG_MUTEXES=n, CONFIG_SCHED_DEBUG=y is getting to be a pretty
> small subset?

Could be, do you fancy me doing a sysctl? shouldn't be hard.

