Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXITHxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXITHxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXITHxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:53:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXITHxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:53:17 -0400
Date: Thu, 20 Sep 2007 09:51:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Tong Li <tong.n.li@intel.com>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070920075155.GA31641@elte.hu>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu> <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com> <1190183324.9737.7.camel@Homer.simpson.net> <1190188261.9185.21.camel@Homer.simpson.net> <1190191368.8687.5.camel@Homer.simpson.net> <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com> <1190264114.6411.4.camel@Homer.simpson.net> <1190272507.27867.20.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190272507.27867.20.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> [...]  I modified the kernel to print task's actual tree key instead 
> of their current vruntime, [...]

btw., that looks like a debug printout bug in sched-devel.git - could 
you send me your fix? I've pushed out the latest sched-devel (ontop of 
-rc7) to the usual place:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

(note that there are some debug printout updates which might clash with 
your fix)

	Ingo
