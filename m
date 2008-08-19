Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYHSO6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYHSO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYHSO6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:58:13 -0400
Received: from gw.goop.org ([64.81.55.164]:59037 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbYHSO6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:58:11 -0400
Message-ID: <48AADF82.6060805@goop.org>
Date: Tue, 19 Aug 2008 07:58:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
 to use function calls [POST 2]
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu>	 <20080819012816.GA7897@elte.hu>  <48AA65A5.8020408@goop.org> <1219139154.10800.380.camel@twins>
In-Reply-To: <1219139154.10800.380.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> spin_lock_nested() has existed for a long time, but you are now using
> spin_lock_nest_lock(), which is a totally different annotation
>   

Yes, typo.  The patch itself uses spin_lock_nest_lock().

    J
