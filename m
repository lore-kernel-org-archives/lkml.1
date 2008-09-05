Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYIELq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYIELq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYIELqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:46:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYIELqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:46:15 -0400
Date: Fri, 5 Sep 2008 13:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Witbrodt <dawitbro@sbcglobal.net>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
	fix v7
Message-ID: <20080905114551.GB27878@elte.hu>
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com> <20080904190457.GB24990@elte.hu> <86802c440809050152p734f54bex60ae512361d79f93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809050152p734f54bex60ae512361d79f93@mail.gmail.com>
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

> On Thu, Sep 4, 2008 at 12:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> v7: remove wrong removing of write_unlock(&resource_lock) in adjust_resource()
> >
> > i've applied the generic commit below to tip/core/resources, and merged
> > tip/core/resources into tip/x86/core, and added the remaining e820.c
> > oneliner change (attached below as well).
> >
> 
> wonder if need to put
> 
>   x86: split e820 reserved entries record to late v4
>   IO resources: add reserve_region_with_split()
>   x86: split e820 reserved entries record to late, v7
> 
> into 2.6.27 for fix hang on David's system.

too late i think. It hung on v2.6.26 too, right? So v2.6.28 would be 
more appropriate, and linux-next or tip/msater can be used as a 
practical kernel in the meanwhile.

	Ingo
