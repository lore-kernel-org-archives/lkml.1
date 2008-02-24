Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYBXN5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYBXN5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYBXN5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:57:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYBXN5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:57:37 -0500
Date: Sun, 24 Feb 2008 14:57:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Message-ID: <20080224135720.GA5323@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802241107.m1OB7bHb022801@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> The kernel for this 486 has CONFIG_M486=y and CONFIG_M586TSC=n, but 
> the 2.6.25 kernels still try to access the TSC. Here's the oops from 
> 2.6.25-rc2-git8:

hm, could you send me the full .config you used?

	Ingo
