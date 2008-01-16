Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYAPWCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYAPWCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYAPWB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:01:56 -0500
Received: from colin.muc.de ([193.149.48.1]:2816 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYAPWB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:01:56 -0500
Date: 16 Jan 2008 23:01:53 +0100
Date: Wed, 16 Jan 2008 23:01:53 +0100
From: Andi Kleen <ak@muc.de>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Message-ID: <20080116220153.GA39717@muc.de>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116203328.GA17869@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This ioremap failing seems to be the real problem. This can be due to
> new tracking of ioremaps introduced by PAT patches. We do not allow
> conflicting ioremaps to same region. Probably that is happening

Normally if there is a conflict there should be a printk (or at least it was
so in the original mattr code if you haven't changed it)

-Andi
