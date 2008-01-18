Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYAREZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYAREZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 23:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYAREZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 23:25:27 -0500
Received: from colin.muc.de ([193.149.48.1]:3251 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAREZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 23:25:22 -0500
Date: 18 Jan 2008 05:25:19 +0100
Date: Fri, 18 Jan 2008 05:25:19 +0100
From: Andi Kleen <ak@muc.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Message-ID: <20080118042518.GA12426@muc.de>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117213131.GA25389@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As Linus mentioned, main problem is to figure out the correct attribute
> for ioremap() which doesn't specify the actual attribute to be used.

In this case the correct attribute is the one of the underlying MTRR.

And if it conflicts with some other mapping that overrides an MTRR
the driver was always broken and it should probably error out and be
reevaluated/fixed.

-Andi
