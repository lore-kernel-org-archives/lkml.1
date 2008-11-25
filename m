Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYKYQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYKYQ5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYKYQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:57:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYKYQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:57:36 -0500
Date: Tue, 25 Nov 2008 17:57:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       suparna@in.ibm.com, linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
Message-ID: <20081125165715.GJ22504@elte.hu>
References: <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com> <20081125145949.GD14147@elte.hu> <20081125151058.GX26308@kernel.dk> <492C1904.9020309@oracle.com> <492C2E12.5000103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492C2E12.5000103@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> Zach Brown wrote:
>> And there's still the question of what ptrace is supposed to do.
>
> If it's kernel-only (which I think is a good start for something 
> like this), then is ptrace relevant at all?

it's relevant wrt. details: to make sure that it's all transparent and 
the ptrace engine is not confused by thread switching tricks.

	Ingo
