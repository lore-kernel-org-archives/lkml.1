Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYCKJWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYCKJWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYCKJWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:22:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYCKJWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:22:17 -0400
Date: Tue, 11 Mar 2008 10:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: gregory.haskins@gmail.com
Cc: ego@in.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: Don't send RESCHEDULE_VECTOR to offlined cpus
Message-ID: <20080311092148.GM25110@elte.hu>
References: <20080310121403.GD17646@in.ibm.com> <20080310122418.GA12101@elte.hu> <20080310125414.GE17646@in.ibm.com> <47D56399.1020504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D56399.1020504@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:

>> Yup, this afternoon while running cpu-hotplug stress tests 
>> (http://lkml.org/lkml/2008/3/3/11) in parallel with kern-bench, I got 
>> this on the serial console.
>
> Note that this may be a side-effect of the bug we are chasing with the 
> rd->online problem.
>
> E.g. if the rd->online issue is causing us to route tasks to dead 
> CPUs, this phenomenon would probably go away once rd->online is fixed 
> (which I believe it is with the patches that were submitted).

yeah, that makes sense. I've applied your patch nevertheless because it 
is the better failure mode for that code.

	Ingo
