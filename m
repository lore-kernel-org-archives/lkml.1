Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbZDNSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbZDNSk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbZDNSk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:40:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbZDNSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:40:24 -0400
Date: Tue, 14 Apr 2009 20:40:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "ego@in.ibm.com" <ego@in.ibm.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Message-ID: <20090414184007.GB11214@elte.hu>
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com> <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org> <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com> <20090414000934.GN817@elte.hu> <20090414033936.GA534@in.ibm.com> <57C9024A16AD2D4C97DC78E552063EA39B3CF29A@orsmsx505.amr.corp.intel.com> <20090414170621.GA1733@in.ibm.com> <57C9024A16AD2D4C97DC78E552063EA39B3CF3B4@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39B3CF3B4@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> -               printk(KERN_CONT " %s (__cpu_power = %d)", str,
> +               printk(KERN_CONT " %s", str);
> +               if (group->__cpu_power != SCHED_LOAD_SCALE)
> +                       printk(KERN_CONT " (__cpu_power = %d)",
>                                                 group->__cpu_power);
> 
> That looks better.
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

Thanks, picked up this variant!

	Ingo
