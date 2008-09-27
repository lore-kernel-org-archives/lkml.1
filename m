Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYI0UC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYI0UC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYI0UCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:02:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbYI0UCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:02:21 -0400
Date: Sat, 27 Sep 2008 22:02:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] - UV fix for size of hub mappings
Message-ID: <20080927200214.GB28937@elte.hu>
References: <20080925125210.GA22404@sgi.com> <20080927174233.GB26047@elte.hu> <20080927195615.GA244243@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927195615.GA244243@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jack Steiner <steiner@sgi.com> wrote:

> > x2apic support is available in tip/master, so it would be nice to 
> > glue UV to generic x2apic support properly and remove duplication 
> > and fixmes.
> 
> Good point. I'll send the fixes to you early next week. Recently, I've 
> been focused on a distro release which is still waiting for the x2apic 
> code. However, I don't need to wait to fix this upstream...

great!

> > For example, do we really need apic_x2apic_uv_x, or could we use 
> > apic_x2apic_cluster?
> 
> Unfortunately, we really need a uv genapic. IPIs on large UV systems 
> can't use an x2apic model. Because of the size of our large systems, 
> APICIDs in the cpu MSRs are not globally unique. We have a special 
> feature in the UV chipset that must be used for on large systems for 
> IPIs. Small & medium sized system can and do use the x2apic genapic.

not a problem really - it's not really complex or intrusive, we just 
want to make sure all unnecessary duplication is eliminated.

	Ingo
