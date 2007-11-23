Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbXKWNxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbXKWNxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 08:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXKWNww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 08:52:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbXKWNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 08:52:51 -0500
Date: Fri, 23 Nov 2007 14:52:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Don't forget to unlock uids_mutex on error paths
Message-ID: <20071123135231.GA13681@elte.hu>
References: <47440D3D.3040609@openvz.org> <20071123131250.GA5771@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123131250.GA5771@linux.vnet.ibm.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> On Wed, Nov 21, 2007 at 01:49:33PM +0300, Pavel Emelyanov wrote:
> > The commit
> > 
> > commit 5cb350baf580017da38199625b7365b1763d7180
> > Author: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Date:   Mon Oct 15 17:00:14 2007 +0200
> > 
> >     sched: group scheduling, sysfs tunables
> > 
> > introduced the uids_mutex and the helpers to lock/unlock it.
> > Unfortunately, the error paths of alloc_uid() were not patched
> > to unlock it.

oops!

> Thanks for catching it. Looks good to me. Ingo, could you please pick 
> these up?

yep - added.

	Ingo
