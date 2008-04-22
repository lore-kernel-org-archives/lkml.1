Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbYDVI4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbYDVI4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYDVI4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:56:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27865 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938AbYDVI4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:56:34 -0400
Date: Tue, 22 Apr 2008 10:56:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function  calls
Message-ID: <20080422085629.GV12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com> <20080422084738.GB2388@elte.hu> <480DA670.4060707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480DA670.4060707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Jacek Luczak wrote:
> Ingo Molnar pisze:
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> >> This converts x86 and x86-64 to use the new helpers for 
> >> smp_call_function() and friends, and adds support for 
> >> smp_call_function_single().
> > 
> > nice stuff. The x86 and generic bits:
> > 
> >  Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > this has been brewing for months, what is the testing/confidence status 
> 
> A'propos testing: Jens did you placed all patches (latest versions)
> somewhere on net, so I can grab it and test?

It's in git as well, generic-ipi branch. So you can pull it into current
linus by doing:

$ git pull git://git.kernel.dk/linux-2.6-block.git generic-ipi

-- 
Jens Axboe

