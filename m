Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYHOQ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYHOQ6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYHOQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:58:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbYHOQ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:58:36 -0400
Date: Fri, 15 Aug 2008 18:58:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] change init_gdt to update the gdt via write_gdt,
	rather than a direct write.
Message-ID: <20080815165821.GA18777@elte.hu>
References: <48A5ACFA.7040906@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A5ACFA.7040906@citrix.com>
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


* Alex Nixon <alex.nixon@citrix.com> wrote:

> From: Alex Nixon <alex.nixon@citrix.com>
> Date: Fri, 15 Aug 2008 11:21:56 +0100
> Subject: [PATCH] change init_gdt to update the gdt via write_gdt, rather than a direct write.
> 
> By writing directly, a memory access violation can occur whilst 
> hotplugging a CPU if the entry was previously marked read-only.

applied to tip/x86/urgent - thanks Alex.

	Ingo
