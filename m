Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbZHXIR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbZHXIR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZHXIR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:17:28 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:61941 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZHXIR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:17:27 -0400
Date: Mon, 24 Aug 2009 10:17:23 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the s390 tree
Message-ID: <20090824081723.GA4798@osiris.boeblingen.de.ibm.com>
References: <20090824170119.57cf4f59.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824170119.57cf4f59.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:01:19PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> arch/s390/kernel/time.c between commit
> 6342887c12d79c5a2c8c1de5be6f483e16a2acdd ("[S390] introduce
> get_clock_monotonic") from the s390 tree and commit
> 23970e389e9cee43c4b41023935e1417271708b2 ("timekeeping: Introduce
> read_boot_clock") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I reverted the sched_clock_base_cc rename. The merge conflict
should be gone as soon as Martin pushes a new tree out.
