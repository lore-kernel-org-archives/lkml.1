Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZJGUfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZJGUfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZJGUfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:35:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53130 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZJGUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:35:02 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
From: Andi Kleen <andi@firstfloor.org>
References: <20091006064919.GB30316@wotan.suse.de>
	<20091006101414.GM5216@kernel.dk>
	<20091006122623.GE30316@wotan.suse.de>
	<20091006124941.GS5216@kernel.dk>
	<20091007085849.GN30316@wotan.suse.de>
	<alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
	<alpine.LFD.2.01.0910070911080.3432@localhost.localdomain>
	<20091007164622.GX30316@wotan.suse.de>
	<alpine.LFD.2.01.0910071222230.3432@localhost.localdomain>
Date: Wed, 07 Oct 2009 22:34:24 +0200
In-Reply-To: <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> (Linus Torvalds's message of "Wed, 7 Oct 2009 12:25:03 -0700 (PDT)")
Message-ID: <87eipfymcv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Sad. But we do have the added requirement that we want to keep the 
> commonly used fields together in the same cacheline, so maybe it's 
> unavoidable.

With some strategic prefetches it might be cheap enough to use 
two cache lines. Just fetch it with the other.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
