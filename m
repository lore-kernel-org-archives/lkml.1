Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYFNI2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYFNI2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYFNI2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:28:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbYFNI2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:28:20 -0400
Date: Sat, 14 Jun 2008 10:28:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup reloated_initrd
Message-ID: <20080614082807.GC11277@elte.hu>
References: <200806132005.45836.yhlu.kernel@gmail.com> <200806132007.03576.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806132007.03576.yhlu.kernel@gmail.com>
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

> 1. move that before zone_sizes_init ...
> 2. add free_early for one old one, otherwise it will be be reserved again when
>    init highmem.

applied to tip/x86/mpparse, thanks.

	Ingo
