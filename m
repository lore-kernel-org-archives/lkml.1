Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZCWTlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZCWTlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbZCWTln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:41:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbZCWTln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:41:43 -0400
Date: Mon, 23 Mar 2009 20:41:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build failure on current -tip
Message-ID: <20090323194130.GB29478@elte.hu>
References: <90edad820903231205g5afc2ed6x621a7231ced7bd23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90edad820903231205g5afc2ed6x621a7231ced7bd23@mail.gmail.com>
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


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

>   CC      arch/x86/kernel/apic/io_apic.o
> cc1: warnings being treated as errors
> arch/x86/kernel/apic/io_apic.c:1431: error: 'msi_ir_chip' defined but not used
> make[2]: *** [arch/x86/kernel/apic/io_apic.o] Error 1
> make[1]: *** [arch/x86/kernel/apic] Error 2
> make: *** [arch/x86/kernel] Error 2

that's a build warning turned into a build failure by:

  # CONFIG_ALLOW_WARNINGS is not set

	Ingo
