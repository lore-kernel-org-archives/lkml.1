Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbYBRNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbYBRNda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYBRNdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:33:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYBRNdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:33:19 -0500
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
From: Andi Kleen <andi@firstfloor.org>
References: <47B0B69B.1050807@hp.com> <47B46008.9020804@hp.com>
	<20080218123717.GW23197@kernel.dk>
Date: Mon, 18 Feb 2008 14:33:17 +0100
In-Reply-To: <20080218123717.GW23197@kernel.dk> (Jens Axboe's message of "Mon\, 18 Feb 2008 13\:37\:17 +0100")
Message-ID: <p73ablyxuci.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> and that scrapping the remote
> softirq trigger stuff is sanest.

I actually liked Nick's queued smp_function_call_single() patch. So even
if it was not used for block I would still like to see it being merged 
in some form to speed up all the other IPI users.

-Andi
