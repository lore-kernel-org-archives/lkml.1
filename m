Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYAQWNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYAQWNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYAQWNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:13:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbYAQWNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:13:40 -0500
Date: Thu, 17 Jan 2008 23:13:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080117221300.GA19977@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117214228.GD12631@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117214228.GD12631@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:

> > but i have not seen this message in your boot log. Could you boot 
> > with early_ioremap_debug and send us the dmesg - i'm curious which 
> > ACPI tables are actively mapped while those devices are initialized.
> 
> Hmm, early_ioremap_debug exists only in ioremap_32.c Have to adapt the 
> 64-bit version first.
> 
> But wait the 64-bit code contains already debug output for this.  See 
> the boot-logs that I have attached to my previous mails. 
> (Interestingly the code for 64-bit early_io(re/un)map resides not in 
> ioremap_64.c but in init_64.c.)

yeah, it's not unified yet.

	Ingo
