Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYAPPQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYAPPQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYAPPQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:16:14 -0500
Received: from saeurebad.de ([85.214.36.134]:57225 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYAPPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:16:13 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, davej@codemonkey.org.uk, rjw@sisk.pl,
       tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch for 2.6.24? 1/1] cpufreq: Initialise default governor before use
In-Reply-To: <20080114091401.GB8026@elte.hu> (Ingo Molnar's message of "Mon,
	14 Jan 2008 10:14:01 +0100")
Date: Wed, 16 Jan 2008 16:17:02 +0100
Message-ID: <87tzldvlzl.fsf@saeurebad.de>
References: <200801140906.m0E962IL020530@imap1.linux-foundation.org>
	<20080114091401.GB8026@elte.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
>> +#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
>> +fs_initcall(cpufreq_gov_dbs_init);
>> +#else
>>  module_init(cpufreq_gov_dbs_init);
>> +#endif
>
> silly question: why not unconditional fs_initcall() ?

Would there be a way to avoid the fs_initcall at all?

Otherwise, this is just a psychological thing to show, hey, this still
sucks, find a better solution.  But perhaps the plain fs_initcall is
marker enough for that fact.

	Hannes
