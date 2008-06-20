Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYFTMwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYFTMwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 08:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFTMvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 08:51:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41140 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYFTMvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 08:51:54 -0400
Date: Fri, 20 Jun 2008 14:51:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] xen: set max_pfn_mapped
Message-ID: <20080620125140.GJ7439@elte.hu>
References: <4856E12B.6040500@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4856E12B.6040500@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0210]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> We need to set max_pfn_mapped, so do so.  Xen guarantees that at least 
> 512k is mapped beyond the end of the kernel image, so we can rely on 
> that being present.

applied all three patches to tip/x86/mm-remove-arch-get-ram-range (on 
which it has dependency) - thanks Jeremy.

	Ingo
