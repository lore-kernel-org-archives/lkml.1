Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYKYP6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYKYP6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYKYP6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:58:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYKYP6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:58:14 -0500
Date: Tue, 25 Nov 2008 16:57:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Avi Kivity <avi@redhat.com>,
       suparna@in.ibm.com, linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
Message-ID: <20081125155753.GA22504@elte.hu>
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com> <20081125145949.GD14147@elte.hu> <20081125151058.GX26308@kernel.dk> <492C1904.9020309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492C1904.9020309@oracle.com>
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


* Zach Brown <zach.brown@oracle.com> wrote:

> > Still unsure why that stuff never got anywhere.
> 
> Changing the tid of submitting tasks makes it unsuitable for 
> sys_io_*() or posix aio users as it stands.  Maybe we could swap 
> tids on the switch, but we'd probably then have to audit the life 
> time of tid -> task_struct users in the kernel.

doesnt look like a big thing affecting the fastpath materially.

> And there's still the question of what ptrace is supposed to do.

debug-only, we sure can work something out.

	Ingo
