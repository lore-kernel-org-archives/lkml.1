Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZG0GYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZG0GYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZG0GYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:24:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZG0GYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:24:47 -0400
Subject: Re: [PATCH] powerpc/perf_counter: Add alignment-faults and
 emulation-faults sw events
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Blanchard <anton@samba.org>, mingo@elte.hu, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <1248675962.6987.1423.camel@twins>
References: <20090706121845.GD4391@kryten>
	 <1248659272.28464.29.camel@pasglop>  <1248675962.6987.1423.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 08:27:01 +0200
Message-Id: <1248676021.6987.1426.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 08:26 +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-27 at 11:47 +1000, Benjamin Herrenschmidt wrote:
> 
> > Sounds good.
> > 
> > BTW. The patch relies on some perctr changes I don't have in my tree
> > (PERF_COUNT_SW_ALIGNMENT_FAULTS isn't defined for me)
> > 
> > Ingo, how do you want to handle that ? Should I wait til round 2 of the
> > merge window before putting Anton's patch in or can I merge some of your
> > stuff in powerpc-next as pre-reqs ? Or you can just take Anton's patch
> > with my:
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > And stick it in your own queue (though pls, give me a pointer to the git
> > tree in question so I can verify that I don't get new stuff that
> > conflicts before we get to the merge window).
> 
> Please send all missing bits to me and I'll stuff it into:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-master

Or if they're all PPC specific I have no objections of them going
through the PPC git tree.
