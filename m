Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYIVKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYIVKF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYIVKFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:05:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYIVKFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:05:49 -0400
Date: Mon, 22 Sep 2008 12:05:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080922100532.GD24705@elte.hu>
References: <20080919123320.GF7222@lenovo> <20080922090405.GA12630@elte.hu> <86802c440809220301l662824aasa9cf3a437f42bd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809220301l662824aasa9cf3a437f42bd9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Mon, Sep 22, 2008 at 2:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> BTW
> 
> x2apic and IRmapping make io_apic.c and apic.c ugly.

yes. Any ideas how to clean it up some more?

the kmalloc looks quite ugly, especially with this kfree() teardown 
sequence we have now.

	Ingo
