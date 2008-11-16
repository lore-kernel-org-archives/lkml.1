Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbYKPJGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbYKPJGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYKPJFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:05:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYKPJFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:05:53 -0500
Date: Sun, 16 Nov 2008 10:05:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: fix es7000 compiling
Message-ID: <20081116090532.GC26595@elte.hu>
References: <86802c440810141017q1e99e98sc824441bafc0cd7a@mail.gmail.com> <20081014175318.GA6521@elte.hu> <48F7890F.9040703@kernel.org> <20081016193345.GA15043@elte.hu> <48F7A838.4040908@kernel.org> <491FDE9B.106@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <491FDE9B.106@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix es7000 compiling
> 
>   CC      arch/x86/kernel/es7000_32.o
> arch/x86/kernel/es7000_32.c: In function ‘find_unisys_acpi_oem_table’:
> arch/x86/kernel/es7000_32.c:255: error: implicit declaration of function ‘acpi_get_table_with_size’
> arch/x86/kernel/es7000_32.c:261: error: implicit declaration of function ‘early_acpi_os_unmap_memory’
> arch/x86/kernel/es7000_32.c: In function ‘unmap_unisys_acpi_oem_table’:
> arch/x86/kernel/es7000_32.c:277: error: implicit declaration of function ‘__acpi_unmap_table’
> make[1]: *** [arch/x86/kernel/es7000_32.o] Error 1

applied to tip/x86/urgent, thanks Yinghai!

	Ingo
