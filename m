Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZFSHbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZFSHbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZFSHa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:30:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZFSHa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:30:59 -0400
Date: Fri, 19 Jun 2009 09:30:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: backtrace symbols are bolixed...
Message-ID: <20090619073053.GA5445@elte.hu>
References: <20090619.002101.45610359.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619.002101.45610359.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> Sometime in the last day or so backtrace symbol printouts
> have become useless:
> 
> [    0.000000] WARNING: at mm/bootmem.c:535 __stop_notes+0xbb10/0x1d660()
> [    0.000000] Modules linked in:
> [    0.000000] Call Trace:
> [    0.000000]  [00000000008611b4] __stop_notes+0xbb10/0x1d660
> [    0.000000]  [000000000086195c] __stop_notes+0xc2b8/0x1d660
> [    0.000000]  [0000000000861a28] __stop_notes+0xc384/0x1d660
> [    0.000000]  [0000000000858678] __stop_notes+0x2fd4/0x1d660
> [    0.000000]  [000000000085684c] __stop_notes+0x11a8/0x1d660
> [    0.000000]  [00000000006e8bdc] _etext+0xfffffffffffe59f4/0xe18
> [    0.000000]  [0000000000000000] (null)
> 
> I'll try to bisect but maybe someone can figure it out quickly
> meanwhile.

I saw this too. One change that went upstream when i started seeing 
these weird backtraces is:

 ad6ccfa: kernel/kallsyms.c: replace deprecated __initcall with device_initcall and fix

Sam and Andrew Cc:-ed.

	Ingo
