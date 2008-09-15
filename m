Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYIOGli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYIOGli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 02:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYIOGl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 02:41:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYIOGl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 02:41:28 -0400
Date: Mon, 15 Sep 2008 08:41:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080915064106.GB15680@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914151404.GA28850@elte.hu> <20080914193140.728F56409D@pipsqueak.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914193140.728F56409D@pipsqueak.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > please uninline these functions.
> 
> They are short and have only one caller.

then they should be defined in the .c file which uses them.

really, sched.h is large enough already and has lots of unnecessary 
stuff in it.

	Ingo
