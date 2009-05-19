Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZESMgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZESMgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZESMf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:35:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZESMf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:35:56 -0400
Date: Tue, 19 May 2009 14:35:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
Message-ID: <20090519123548.GA26439@elte.hu>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's a revised set of the Xen APIC changes which adds 
> io_apic_ops to allow Xen to intercept IO APIC access operations.

In a previous discussion you said:

> IO APIC operations are not even slightly performance critical? Are 
> they ever used on the interrupt delivery path?

Since they are not performance critical, then why doesnt Xen catch 
the IO-APIC accesses, and virtualizes the device?

If you want to hook into the IO-APIC code at such a low level, why 
dont you hook into the _hardware_ API - i.e. catch those 
setup/routing modifications to the IO-APIC space. No Linux changes 
are needed in that case.

	Ingo
