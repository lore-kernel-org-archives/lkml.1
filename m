Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXLMJC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXLMJC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXLMJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:02:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbXLMJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:02:04 -0500
Date: Thu, 13 Dec 2007 10:01:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark timer_stats as incompatible with multiple pid
	namespaces
Message-ID: <20071213090102.GB1926@elte.hu>
References: <m13au7tsov.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13au7tsov.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> /proc/timer_stats currently reports the user of a timer by pid, which 
> is a reasonable approach.  However if you are not in the initial pid 
> namespace the pid that is reported is nonsense.
> 
> Therefore until we can make timer_stats pid namespace safe just 
> disable it in the build if pid namespace support is selected so we at 
> least know we have a conflict.

What the heck??? Please solve this properly instead of hiding it. 
/proc/timer_stats is damn useful and it's a must-have for powertop to 
work.

	Ingo
