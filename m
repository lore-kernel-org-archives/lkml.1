Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYFZJsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYFZJsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYFZJr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:47:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYFZJr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:47:56 -0400
Date: Thu, 26 Jun 2008 11:47:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/16] x86: merge setup_32/64.c
Message-ID: <20080626094743.GA19573@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> please check the patches
> 
> it will rename setup.c to setup_percpu.c and make setup_32.c to 
> support 64bit, and then change setup_32.c to setup.c and delete 
> setup_64.c.

applied them to tip/x86/unify-setup:

 Yinghai Lu (17):
      x86: fix memory setup bug
      x86: rename setup.c to setup_percpu.c
      x86: we can use full bootmem after have init_memory_mapping
      x86: update reserve_initrd to support 64bit
      x86: put global variable for 32bit all together
      x86: add extra includes for 64bit support
      x86: merge 64bit setup_arch into setup_32
      x86: space to tab in setup_arch
      x86: rename setup_32.c to setup.c
      x86: move boot_params back to setup.c
      x86: move parse_setup_data back to setup.c
      x86: move back crashkernel back to setup.c
      x86: move reserve_standard_io_resources back to setup.c
      x86: move parse elfvorehdr back to setup.c
      x86: make x86_find_smp_config depends on 64 bit too
      x86: change some functions in setup.c to static
      x86: we only have init_pg_tables_end for 32bit

thanks Yinghai.

	Ingo
