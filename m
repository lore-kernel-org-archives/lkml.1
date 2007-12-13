Return-Path: <linux-kernel-owner+w=401wt.eu-S1765064AbXLMUWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765064AbXLMUWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXLMUWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:22:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbXLMUWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:22:30 -0500
Date: Thu, 13 Dec 2007 21:21:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: vincent.fortier1@ec.gc.ca, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213202125.GA25130@elte.hu>
References: <1197554397.19869.3.camel@lov.site> <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca> <1197562981.19869.5.camel@lov.site> <20071213165059.GC4865@elte.hu> <1197565842.19869.11.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197565842.19869.11.camel@lov.site>
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


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> > > > This one also fails to apply properly at the exact same place 
> > > > has Ingo's previously posted patch.  Would need to backport his 
> > > > one.
> > > 
> > > It depends on a completely reworked sysfs logic, I don't think it 
> > > makes any sense to backport that.
> > 
> > well, if it fixes a live bug in a still supported stable kernel 
> > release...
> > 
> > Vincent, could you try to just get rid of all actual uses of 
> > se->attr.owner, within fs/sysfs/*.c? Something like the patch below. 
> > (totally untested - might be fatally broken as well)
> 
> How can you think that this is not needed? You can not remove it with 
> sysfs you are patching. Hope this explains it: 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0ab66088c855eca68513bdd7442a426c4b374ced

yeah - as i said it might be fatally broken (in fact it is). Do we 
understand why Vincent got the crashes with vanilla 2.6.22.14 ?

	Ingo
