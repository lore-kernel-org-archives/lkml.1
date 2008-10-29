Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYJ2NP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYJ2NP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYJ2NPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:15:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41693 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYJ2NPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:15:15 -0400
Date: Wed, 29 Oct 2008 14:06:59 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with	BIOVEC_PHYS_MERGEABLE
Message-ID: <20081029130658.GB31673@kernel.dk>
References: <20081029080603J.fujita.tomonori@lab.ntt.co.jp> <20081029083713.GE6364@elte.hu> <49082BBC.60302@goop.org> <20081029105113.GA15981@elte.hu> <20081029112504.GA1935@elte.hu> <20081029112745.GT22217@kernel.dk> <20081029113016.GA3751@elte.hu> <49085326.1050408@goop.org> <20081029130338.GA26282@elte.hu> <49085FD2.9090604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49085FD2.9090604@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30 2008, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >uhm, 1/2 changes bio.h. I'll let both patches alone for now ;-)
> 
> OK, 1/2 should be applied one way or another.  It's not critical, but it 
> avoids duplicating code if/when an arch/io.h wants to override 
> BIOVEC_PHYS_MERGEABLE.

I'll get it upstream.

-- 
Jens Axboe

