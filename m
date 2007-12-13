Return-Path: <linux-kernel-owner+w=401wt.eu-S933582AbXLMVhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbXLMVhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbXLMVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:37:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933539AbXLMVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:37:35 -0500
Date: Thu, 13 Dec 2007 22:37:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark timer_stats as incompatible with multiple pid
	namespaces
Message-ID: <20071213213710.GB25563@elte.hu>
References: <m13au7tsov.fsf@ebiederm.dsl.xmission.com> <20071213090102.GB1926@elte.hu> <m1r6hqstat.fsf@ebiederm.dsl.xmission.com> <20071213130423.GB28340@elte.hu> <m1ir32sejc.fsf@ebiederm.dsl.xmission.com> <20071213202621.GC25130@elte.hu> <m1prxaqo62.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prxaqo62.fsf@ebiederm.dsl.xmission.com>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> >> Well struct pid * works in that case if you grab the reference to 
> >> it.
> >
> > but the display of the stats might happen much later. The point of 
> > this API is to save pid+comm, which gives users a good idea about 
> > what caused the events in the past - without having to pin any 
> > resource of that task.
> 
> Likewise struct pid is designed not to be a problem if pinned. It is a 
> little heavier then it used to be with the addition of pid namespace 
> support but not much.  And if it is to heavy struct pid needs to be 
> fixed.
> 
> Holding the struct pid very much does not pin the task struct, and it 
> shouldn't pin any other resources.  I agree 64bytes or so is a bit 
> more to pin then 4 bytes but it really isn't a lot.

yeah, and i have no conceptual objections - i just wanted to outline the 
thinking behind /proc/timer_stats.

	Ingo
