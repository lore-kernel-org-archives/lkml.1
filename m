Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbZCEVZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbZCEVZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZCEVZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:25:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZCEVZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:25:46 -0500
Date: Thu, 5 Mar 2009 22:25:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>, Tejun Heo <tj@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86-tip] overflow in relocation type 11 val 39ffdd0e8690
Message-ID: <20090305212535.GA13848@elte.hu>
References: <1236287654.3677.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236287654.3677.3.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On latest tip I am getting:
> 
> [  124.169475] overflow in relocation type 11 val 39ffdd0e8690
> [  124.169508] `msr_debug' likely not compiled with -mcmodel=kernel
> [  146.582299] overflow in relocation type 11 val 39ffdd0e8690
> [  146.582299] `msr_debug' likely not compiled with -mcmodel=kernel
> [  836.653168] overflow in relocation type 11 val 39ffdd0e8690
> [  836.653201] `msr_debug' likely not compiled with -mcmodel=kernel
> 
> But 1d10914bf2c8 was working fine.

That's a linker bug - Tejun Cc:-ed.

	Ingo
