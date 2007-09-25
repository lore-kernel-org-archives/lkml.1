Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXIYN4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXIYN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXIYN4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:56:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34833 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXIYN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:56:31 -0400
Date: Tue, 25 Sep 2007 19:37:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925140707.GO26289@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com> <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu> <20070925102855.GL26289@linux.vnet.ibm.com> <20070925103617.GA3426@elte.hu> <20070925125129.GA26310@linux.vnet.ibm.com> <1190727317.11260.8.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190727317.11260.8.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 03:35:17PM +0200, Mike Galbraith wrote:
> > I tried the following patch. I *think* I see some improvement, wrt
> > latency seen when I type on the shell. Before this patch, I noticed
> > oddities like "kill -9 chew-max-pid" wont kill chew-max (it is queued in
> > runqueue waiting for a looong time to run before it can acknowledge
> > signal and exit). With this patch, I don't see such oddities ..So I am hoping 
> > it fixes the latency problem you are seeing as well.
> 
> http://lkml.org/lkml/2007/9/25/117 plus the below seems to be the SIlver
> Bullet for the latencies I was seeing.

Cool ..Thanks for the quick feedback.

Ingo, do the two patches fix the latency problems you were seeing as
well?

-- 
Regards,
vatsa
