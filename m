Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYIKHrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYIKHrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYIKHrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:47:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYIKHrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:47:39 -0400
Date: Thu, 11 Sep 2008 09:47:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bryan Wu <cooloney@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       vapier.adi@gmail.com
Subject: Re: [PATCH] fastboot: fix blackfin breakage due to vmlinux.lds
	change
Message-ID: <20080911074724.GG12087@elte.hu>
References: <20080910082534.12344a1c@infradead.org> <386072610809102043ie1107dp45e46889483048e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610809102043ie1107dp45e46889483048e7@mail.gmail.com>
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


* Bryan Wu <cooloney@kernel.org> wrote:

> On Wed, Sep 10, 2008 at 11:25 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > Hi,
> >
> > the patch below fixes the fastboot bug as reported by Mike Frysinger;
> > I've commited this to
> > git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git
> >
> > Ingo, please also add to -tip
> >
> >
> > From 16aeda33acbb711863d8fff78c15b32ad0d4aa89 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Wed, 10 Sep 2008 08:22:26 -0700
> > Subject: [PATCH] fastboot: fix blackfin breakage due to vmlinux.lds change
> >
> > As reported by Mike Frysinger, the vmlinux.lds changes should
> > have used VMLINUX_SYMBOL()...
> >
> 
> Thanks a lot, Mike and Arjan. This issue was found by Mike's auto
> nightly building machine.
> 
> Acked-by: Bryan Wu <cooloney@kernel.org>

applied to tip/fastboot, thanks!

	Ingo
