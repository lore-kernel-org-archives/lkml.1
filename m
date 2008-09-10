Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYIJILH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYIJILH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYIJIKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:10:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbYIJIKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:10:49 -0400
Date: Wed, 10 Sep 2008 10:10:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] xen: fix pinning when not using split pte locks
Message-ID: <20080910081027.GD15255@elte.hu>
References: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org> <48C6F80E.8010509@citrix.com> <48C6FC0D.9040009@goop.org> <48C70526.1030701@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C70526.1030701@citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Nixon <alex.nixon@citrix.com> wrote:

> Jeremy Fitzhardinge wrote:
>> We only pin PTE pages when using split PTE locks, so don't do the
>> pin/unpin when attaching/detaching pte pages to a pinned pagetable.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>   
> Cheers Jeremy - a better solution.  Worth mentioning - this doesn't  
> exist peacefully alongside my patch 965fe78fe
>
> Ingo - could you revert that please?

yes - that looked odd and un-ack-ed anyway - but i applied it [it's at 
the tail of x86/xen and easy to zap] because it solved a BUG_ON().

Btw., i suggested a different workflow to you in the past: please run 
Xen patches by Jeremy and ask him for Acks and Cc: him - thanks.

	Ingo
