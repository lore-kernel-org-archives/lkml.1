Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbYG1Odw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYG1Odw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYG1Odo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:33:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYG1Odn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:33:43 -0400
Date: Mon, 28 Jul 2008 16:33:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] xen: suppress known wrmsrs
Message-ID: <20080728143326.GG18144@elte.hu>
References: <4888EABA.1030608@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4888EABA.1030608@goop.org>
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

> In general, Xen doesn't support wrmsr from an unprivileged domain; it 
> just ends up ignoring the instruction and printing a message on the 
> console.
>
> Given that there are sets of MSRs we know the kernel will try to write 
> to, but we don't care, just eat them in xen_write_msr to cut down on 
> console noise.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/xen - thanks,

	Ingo
