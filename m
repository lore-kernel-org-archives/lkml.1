Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYG1M1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYG1M1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYG1M1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:27:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYG1M1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:27:08 -0400
Date: Mon, 28 Jul 2008 14:26:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] xen: fix allocation and use of large ldts
Message-ID: <20080728122648.GC5515@elte.hu>
References: <488C97FE.2010606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488C97FE.2010606@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0156]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When the ldt gets to more than 1 page in size, the kernel uses vmalloc
> to allocate it.  This means that:
> - when making the ldt RO, we must update the pages in both the vmalloc
>   mapping and the linear mapping to make sure there are no RW aliases.
> - we need to use arbitrary_virt_to_machine to compute the machine addr
>   for each update

applied to tip/x86/xen, thanks Jeremy.

	Ingo
