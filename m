Return-Path: <linux-kernel-owner+w=401wt.eu-S965499AbXCLK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbXCLK2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965510AbXCLK2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:28:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965499AbXCLK2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:28:20 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
       oleg@tv-sign.ru, sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net>
	<20070312011259.3834A1801C4@magilla.sf.frob.com>
	<20070312091006.GF21024@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Mar 2007 12:27:30 +0100
In-Reply-To: <20070312091006.GF21024@elte.hu>
Message-ID: <p73bqiyaehp.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> the only correct approach is the use of hrtimers, and a patch exists for 
> that - see below. This has been included in -rt for quite some time.

But isn't that bad for power management? You'll likely get more
idle wakeups, won't you?

-Andi

