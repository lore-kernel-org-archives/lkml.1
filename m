Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZJXI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZJXI7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 04:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZJXI7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 04:59:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZJXI7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 04:59:15 -0400
Date: Sat, 24 Oct 2009 10:58:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: roland@redhat.com, akpm@linux-foundation.org, oleg@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
Message-ID: <20091024085848.GA23215@elte.hu>
References: <4AE1804A.2050404@miraclelinux.com> <20091023114600.GG5886@elte.hu> <4AE2A6A1.1070904@miraclelinux.com> <4AE2C151.8070006@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE2C151.8070006@miraclelinux.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:

> Hi Ingo, Roland,
>
> Now, I received a nice comment from OGAWA-san.
> How is this impriment like a print_faital_signal().
>
> I think it's very nice.

Agreed - i just wanted to suggest that too. print_fatal_signals is 
already a switch that turns on warnings about 'weird looking signal 
behavior'. print-on-overflow seems like a good match.

	Ingo
