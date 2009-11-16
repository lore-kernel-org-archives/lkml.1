Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZKPKuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZKPKuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZKPKuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:50:18 -0500
Received: from www.tglx.de ([62.245.132.106]:51944 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZKPKuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:50:17 -0500
Date: Mon, 16 Nov 2009 11:49:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, yinghai@kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] Remove SMP ifdef from irq_desc
In-Reply-To: <20091110185716.GA4665@sgi.com>
Message-ID: <alpine.LFD.2.00.0911161120550.24119@localhost.localdomain>
References: <20091021011233.GB32196@sgi.com> <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org> <20091108145355.GA8432@elte.hu> <20091109160215.GA14718@sgi.com> <20091110044025.GA7897@elte.hu> <20091110163118.GA13707@sgi.com> <20091110171910.GA25581@elte.hu>
 <20091110185716.GA4665@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Dimitri Sivanich wrote:

> Remove the CONFIG_SMP ifdef from the irq_desc structure and consolidate
> initializers for the smp/non-smp cases.
> 
> For the x86_32 case, this adds 4 bytes of text and 128 bytes of data.
> For the x86_64 case, this adds 15 bytes of text and 240 bytes of data.

Hmm, on ARM and PowerPC the increase of data is 4K and I expect it's
minimum the same on other architectures. Not sure if we should worry
about it, but it's definitely a significant number.

Thanks,

	tglx



