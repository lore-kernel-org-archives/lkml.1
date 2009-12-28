Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZL1JpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZL1JpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZL1JpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:45:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbZL1JpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:45:21 -0500
Date: Mon, 28 Dec 2009 10:44:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091228094444.GG24690@elte.hu>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
 <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> On Sat, 26 Dec 2009, Len Brown wrote:
> 
> > > [   28.643216] evbug.c: Connected device: input1 (Dell WMI hotkeys at wmi/input0)
> > > [   28.650449] BUG: unable to handle kernel NULL pointer dereference at 00000014
> > > [   28.654439] IP: [<c17f7f21>] wmi_install_notify_handler+0x31/0x70
> > 
> > Rather than reverting the broken patch that caused wmi to load,
> > does applying this patch to deal with the broken error handling
> > cause the oops to go away?
> 
> > Subject: [PATCH] Revert "wmi: Free the allocated acpi objects through wmi_get_event_data"
> > 
> > This reverts commit 3e9b988e4edf065d39c1343937f717319b1c1065.
> 
> These kfree's look correct, assuming we properly check
> the return status.  So perhaps instead you can test
> the patch below?

Applied it to tip:out-of-tree for testing, and have dropped the revert as 
well. Will let you know how it goes. (if you dont hear from me later today you 
an assume it's all fixed.)

Thanks,

	Ingo
