Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYGXKeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYGXKeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYGXKeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:34:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYGXKeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:34:10 -0400
Date: Thu, 24 Jul 2008 12:33:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       heukelum@fastmail.fm, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86_64, dwarf2: push pushes 8 bytes and popf pops 8
Message-ID: <20080724103357.GF28817@elte.hu>
References: <20080722161416.GA17699@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722161416.GA17699@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> The CFI_ADJUST_CFA_OFFSET dwarf2 annotation of a push/popf pair in 
> ret_from_fork wrongly used a value of 4. It should have been 8. Fix 
> that.

applied to tip/x86/debug - thanks Alexander.

	Ingo
