Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbZDQQmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbZDQQmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761346AbZDQQl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:41:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759122AbZDQQlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:41:55 -0400
Date: Fri, 17 Apr 2009 18:41:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: fix section mismatch warnings
Message-ID: <20090417164141.GJ8253@elte.hu>
References: <1239918902.10567.22.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239918902.10567.22.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> The following changes since commit 88dc4c8e38d64db32907e0bd605f8c1ec4c4d1bd:
>   Ingo Molnar (1):
>         Merge branch 'tracing/ftrace'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (3):
>       x86: mm/numa_32.c calculate_numa_remap_pages should use __init
>       x86: apic/es7000_32.c find_unisys_acpi_oem_table and es7000_acpi_madt_oem_check should use __init
>       x86: smpboot.c wakeup_secondary_cpu_via_nmi do not required __devinit

The commit logs lack analysis. The suggestions in the warnings are 
advisory and can be wrong. Analysis explaining what happened, maybe 
even when it happened, and what should be done about it to fix that 
issue is needed in such changelogs.

The commits might be correct - or they might be bogus. The commit 
logs dont give us any help in deciding that. I.e. if you did that 
work, you should document it. If you _didnt_ do that analysis work, 
you shouldnt send patches addressing these types of warnings.

	Ingo
