Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYHULxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYHULxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbYHULx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:53:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760048AbYHULxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:53:25 -0400
Date: Thu, 21 Aug 2008 13:53:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] Xen spinlock updates and performance
	measurements
Message-ID: <20080821115304.GF30667@elte.hu>
References: <patchbomb.1219276937@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1219276937@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This series has some updates to Xen's spinlock implementation,
> including adding a set of performance measurements in debugfs.
> 
> The series consists of:
>  - correctly deal with a spinlock in an interrupt handler interrupting
>    another spinlock spinning on a lock. [2.6.27 bugfix]
>  - Add Xen debugfs support, including performance metrics for
>    spinlocks, multicalls and mmu operations.
>  - Allow interrupts to be enabled while spinning (blocking) for a lock
>  - Measure time spinlocks spend blocked

applied to tip/x86/xen - thanks Jeremy.

	Ingo
