Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbYA1RfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbYA1RfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYA1RfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:35:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYA1RfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:35:08 -0500
Date: Mon, 28 Jan 2008 18:34:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jeremy@goop.org
Subject: Re: git-x86 oopses in acpi_ps_peek_opcode
Message-ID: <20080128173449.GA22487@elte.hu>
References: <20080128171907.GA24037@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128171907.GA24037@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> git-x86 tip  5b838c0d9d7269eb4d21532da126b3c90db46c67 with x86-64 defconfig
> oopses on boot with 
> 
> BUG: unable to handle kernel paging request at ffffc20001815000
> IP: [<ffffffff803773e8>] acpi_ps_peek_opcode+0x4/0x1c
> PGD 12fc32067 PUD 32fc24067 PMD 32f42c067 PTE 0

ok, this looks like one of the bugs we fixed in the latest x86.git 
(freshly released a few minutes ago). Could you please check x86.git#mm 
with this tip:

  commit cc77c9972685ea84908eff2fe13114160de5d9cb
  Author: Thomas Gleixner <tglx@linutronix.de>
  Date:   Mon Jan 28 18:18:43 2008 +0100

      x86: cpa: rename global_flush_tlb() to cpa_flush_all()

do you still see that crash?

	Ingo
