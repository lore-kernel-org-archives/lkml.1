Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbXF3TWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbXF3TWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXF3TWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:22:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXF3TV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:21:59 -0400
Date: Sat, 30 Jun 2007 21:20:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Stephane Eranian <eranian@hpl.hp.com>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [1/2] 2.6.22-rc6: known regressions with patches
Message-ID: <20070630192045.GA3720@elte.hu>
References: <467F8F5A.3000205@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467F8F5A.3000205@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject    : fix nmi_watchdog=2 bootup hang
> References : http://lkml.org/lkml/2007/6/25/51
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Caused-By  : Jeremy Fitzhardinge <jeremy@xensource.com>
>             Andi Kleen <ak@suse.de>
>             commit f8822f42019eceed19cc6c0f985a489e17796ed8
> Status     : patch available

fixed by:

 commit b9e3614f444f6546204f4538afcaa3ebe36d49f2
 Author: Bj<C3><B6>rn Steinbrink <B.Steinbrink@gmx.de>
 Date:   Mon Jun 25 23:04:37 2007 +0200

     fix nmi_watchdog=2 bootup hang

	Ingo
