Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYAONXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYAONXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYAONXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:23:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYAONXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:23:09 -0500
Date: Tue, 15 Jan 2008 14:22:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, ebiederm@xmission.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: checking aperture report for node instead of
	cpu
Message-ID: <20080115132253.GC7025@elte.hu>
References: <200801101914.47967.yinghai.lu@sun.com> <200801120207.19981.yinghai.lu@sun.com> <20080114083545.GF18296@elte.hu> <200801141739.35448.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801141739.35448.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> -		printk(KERN_INFO "CPU %d: aperture @ %Lx size %u MB\n",
> -				num-24, aper_base, aper_size>>20);
> +		printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
> +				node++, aper_base, aper_size >> 20);

please dont put side-effects into printks. (put the node++ iteration out 
into a separate line) Your patch looks fine otherwise.

	Ingo
