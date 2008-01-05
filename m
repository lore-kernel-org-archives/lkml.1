Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYAEPLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYAEPLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYAEPLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:11:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbYAEPLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:11:44 -0500
Date: Sat, 5 Jan 2008 16:11:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, pavel@suse.cz
Subject: Re: [PATCH] i386 : Make arch/x86/kernel/acpi/wakeup_32.S use a
	separate text section
Message-ID: <20080105151134.GB9595@elte.hu>
References: <20080103210426.35543645.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103210426.35543645.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> # size vmlinux.before vmlinux.after
>    text    data     bss     dec     hex filename
> 4619942  422838  458752 5501532  53f25c vmlinux.before
> 4610534  422838  458752 5492124  53cd9c vmlinux.after
> 
> This saves 9408 bytes

that's nice! Applied it to x86.git. I'm wondering, do we have other such 
cases? page alignment requirements are quite often for various CPU data 
structures.

	Ingo
