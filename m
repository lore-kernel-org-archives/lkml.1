Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYGTJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYGTJAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYGTJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:00:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbYGTJAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:00:23 -0400
Date: Sun, 20 Jul 2008 11:00:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] - Earlier detection of system type (UV or non-UV)
Message-ID: <20080720090006.GA24915@elte.hu>
References: <20080709163602.GA12543@sgi.com> <20080718171331.GK6875@elte.hu> <20080718174929.GA981@elte.hu> <20080718183800.GA26109@sgi.com> <20080718201324.GA18198@elte.hu> <20080718212818.GA13514@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718212818.GA13514@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> A patch is coming that requires earlier detection of system type (UV 
> or non-UV) Move the logic that detects whether running on UV to 
> acpi_boot_table_init().
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

hm, shouldnt the UV x2apic code be consolidated into the new apic_ops 
that is in the tip/x2apic branch? Plus the new x86_quirks method that 
allows the general bootup to pick up various system-specific quirks. 
It's all in tip/master:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
