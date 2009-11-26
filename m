Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbZKZIM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbZKZIM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbZKZIMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:12:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40880 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759480AbZKZIMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:12:55 -0500
Date: Thu, 26 Nov 2009 09:12:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the tip tree
Message-ID: <20091126081237.GA31034@elte.hu>
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Tejun,
> 
> Today's linux-next merge of the workqueues tree got a conflict in
> kernel/sched.c between commit eae0c9dfb534cb3449888b9601228efa6480fdb5
> ("sched: Fix and clean up rate-limit newidle code") from the tip tree and
> commit 710c15b748f5ce9c573cc047f419cf007a677a9a ("sched: refactor
> try_to_wake_up() and implement try_to_wake_up_local()") from the
> workqueues tree.

Tejun,

Please submit scheduler patches to the scheduler tree. Such level of 
refactoring of a critical scheduler component needs to go through the 
regular scheduler channels. This is a frequently modified piece of code 
and conflicts are likely in the future.

Thanks,

	Ingo
