Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbYGRUVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbYGRUVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYGRUVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:21:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34064 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552AbYGRUVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:21:33 -0400
Date: Fri, 18 Jul 2008 22:21:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       jbarnes@virtuousgeek.org, Jack Howarth <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080718202118.GC24122@elte.hu>
References: <200807180941.09779.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807180941.09779.yhlu.kernel@gmail.com>
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

> change the mconf bus range from [0,0xff] to to [0, 0x3f] to match 
> range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>

great find!

If you can think of further debug mechanisms in the kernel to make the 
fixing of similar problems easier, feel free ... The easier it is for 
users to track down such problems the better for Linux in general.

	Ingo
