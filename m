Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbYDVIwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbYDVIwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbYDVIwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:52:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19795 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbYDVIwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:52:37 -0400
Date: Tue, 22 Apr 2008 10:52:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function  calls
Message-ID: <20080422085233.GU12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com> <20080422084738.GB2388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422084738.GB2388@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > This converts x86 and x86-64 to use the new helpers for 
> > smp_call_function() and friends, and adds support for 
> > smp_call_function_single().
> 
> nice stuff. The x86 and generic bits:
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks, adding...

> this has been brewing for months, what is the testing/confidence status 
> of it? Could we still merge it into v2.6.26? (i think we should)

I'm not aware of any problems. I'd be very grateful if you could give it
a spin on some of your test boxes, just to raise the confidence interval
a bit :-)

-- 
Jens Axboe

