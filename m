Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZCFSqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZCFSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZCFSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:45:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbZCFSpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:45:33 -0500
Date: Fri, 6 Mar 2009 19:45:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stable@kernel.org, dan.yeisley@unisys.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: MSI: check for BIOS assigned addresses
Message-ID: <20090306184514.GC15526@elte.hu>
References: <1236352309.31604.2.camel@localhost.localdomain> <tip-affd49d36e2e2df4cbb3e07a57db901c23823b6a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-affd49d36e2e2df4cbb3e07a57db901c23823b6a@git.kernel.org>
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


* Daniel Yeisley <dan.yeisley@unisys.com> wrote:

> Commit-ID:  affd49d36e2e2df4cbb3e07a57db901c23823b6a
> Gitweb:     http://git.kernel.org/tip/affd49d36e2e2df4cbb3e07a57db901c23823b6a
> Author:     "Daniel Yeisley" <dan.yeisley@unisys.com>
> AuthorDate: Fri, 6 Mar 2009 10:11:49 -0500
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 6 Mar 2009 19:32:44 +0100
> 
> x86: MSI: check for BIOS assigned addresses
> 
> Impact: fix ACPI hotplug on certain systems

Note, this commit means that i moved the commit over from 
tip:x86/urgent into tip:x86/apic - i.e. with a 2.6.30 merge 
date. When exactly was this regression introduced? I think this 
code never really accepted the MSI settings from the firmware, 
so changing that behavior might affect a lot of systems.

So i'm uneasy about applying this fix this late in the .29 
cycle, but marked it for -stable backport so it could hit 
2.6.29.1 if it stays problem-free.

	Ingo
