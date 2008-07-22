Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYGVIg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYGVIg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYGVIgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:36:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbYGVIgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:36:50 -0400
Date: Tue, 22 Jul 2008 10:36:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
Message-ID: <20080722083626.GC2065@elte.hu>
References: <200807221431.58991.rusty@rustcorp.com.au> <488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au> <4885774E.3000909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885774E.3000909@goop.org>
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

> Rusty, in his peevish way, complained that macros defining constants 
> should have a name which somewhat accurately reflects the actual 
> purpose of the constant.
>
> Aside from the fact that PTE_MASK gives no clue as to what's actually 
> being masked, and is misleadingly similar to the functionally entirely 
> different PMD_MASK, PUD_MASK and PGD_MASK, I don't really see what the 
> problem is.

Has Rusty ever heard about the economy of the healthy flow of incoming 
regressions? What will we do without obscure names and hard to find 
bugs? First he writes a simple and readable hypervisor (ruining a whole 
industry based on obscurity!) and now that. It's _so_ unamerican and 
unaustralian. I'm worried.

Applied to tip/x86/cleanups anyway. Rusty will find out himself how bad 
this whole concept of clean and understandable code is, soon enough!

	Ingo
