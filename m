Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607AbZJTJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbZJTJVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZJTJVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:21:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:57018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZJTJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 05:21:21 -0400
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20091020061557.GE8550@elte.hu>
References: <4ADB967A.4080707@suse.com>
	 <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz>
	 <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz>
	 <20091020061557.GE8550@elte.hu>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 11:21:14 +0200
Message-Id: <1256030474.17774.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 08:15 +0200, Ingo Molnar wrote:
> 
> Seems like an IA64 bug to me. It's _very_ easy to get more than 64K of 
> percpu data - i'm wondering why IA64 only triggered it now? Sure 
> lockdep/lockstat must have triggered it before.

I seem to remember people wanting to make lockstat data dynamically
allocated because of this.

But then, I'm not sure ia64 actually has lockdep support.

