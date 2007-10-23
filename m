Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXJWT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXJWT4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXJWT4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:56:31 -0400
Received: from mail.suse.de ([195.135.220.2]:50743 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbXJWT4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:56:30 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
From: Andi Kleen <andi@firstfloor.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
	<1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
	<471E2A96.7050304@panasas.com> <20071023183321.GA14671@kernel.dk>
Date: Tue, 23 Oct 2007 21:56:28 +0200
In-Reply-To: <20071023183321.GA14671@kernel.dk> (Jens Axboe's message of "Tue\, 23 Oct 2007 20\:33\:21 +0200")
Message-ID: <p738x5t4nbn.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> You might want to put a BUG_ON(page & 0x3); Make sure
>> you're not loosing information. (The m68k problem)
>
> That's a really good idea, thanks Boaz! I'll add that.

It would be even better if you replaced all the magic numbers with defines
or better accessors.

-Andi
