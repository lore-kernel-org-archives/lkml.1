Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbZG0E5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbZG0E5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 00:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZG0E5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 00:57:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:39469 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZG0E5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 00:57:37 -0400
Subject: Re: [PATCH] powerpc/perf_counter: Add alignment-faults and
 emulation-faults sw events
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anton Blanchard <anton@samba.org>
Cc: linuxppc-dev@ozlabs.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
In-Reply-To: <20090727015134.GA18301@kryten>
References: <20090706121845.GD4391@kryten>
	 <1248659272.28464.29.camel@pasglop>  <20090727015134.GA18301@kryten>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 14:57:10 +1000
Message-Id: <1248670630.5706.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 11:51 +1000, Anton Blanchard wrote:
> Hi Ben,
> 
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
> I've got another round of this series that I'll send out today.

Ok. I've pushed some to my -test branch, please let me know ASAP if I
have to withdraw some before I move them into -next

Cheers,
Ben.


