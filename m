Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbXIYLBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbXIYLBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXIYLBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:01:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36014 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbXIYLBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:01:00 -0400
Date: Tue, 25 Sep 2007 13:00:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925110046.GA11262@elte.hu>
References: <20070924214537.GA18980@elte.hu> <20070925004120.3650c9c1.akpm@linux-foundation.org> <20070925084327.GI26289@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925084327.GI26289@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Sep 25, 2007 at 12:41:20AM -0700, Andrew Morton wrote:
> > This doornails the Vaio.  After grub handover the screen remains black
> > and the fan goes whir.
> > 
> > http://userweb.kernel.org/~akpm/config-sony.txt
> 
> This seems to be UP regression. Sorry abt that. I could recreate 
> the problem very easily with CONFIG_SMP turned off.
> 
> Can you check if this patch works? Works for me here.

thanks - i've put this fix into the core group-scheduling patch.

	Ingo
