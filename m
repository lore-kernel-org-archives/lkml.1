Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYBXHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYBXHvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYBXHvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:51:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYBXHvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:51:09 -0500
Date: Sun, 24 Feb 2008 08:50:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be
	clustered_box v2
Message-ID: <20080224075039.GA9052@elte.hu>
References: <200802210258.45011.yinghai.lu@sun.com> <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802232148.43255.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> quad core 8 socket system will have apic id lifting.the apic id range 
> could be [4, 0x23]. and apic_is_clustered_box will think that need to 
> three clusters and that is large than 2. So it is treated as 
> clustered_box.
> 
> and will get
> 
> Marking TSC unstable due to TSCs unsynchronized
> 
> even the CPUs have X86_FEATURE_CONSTANT_TSC set.
> 
> this patch will check if the cpu is from AMD.

thanks Yinghai, applied.

	Ingo
