Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYKWMdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYKWMdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYKWMc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:32:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYKWMc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:32:57 -0500
Date: Sun, 23 Nov 2008 13:32:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: pin correct PGD on suspend
Message-ID: <20081123123241.GH29663@elte.hu>
References: <1227262893-27335-1-git-send-email-Ian.Campbell@citrix.com> <4926E2A2.2060602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926E2A2.2060602@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ian Campbell wrote:
>> commit eefb47f6a1e855653d275cb90592a3587ea93a09 ("xen: use
>> spin_lock_nest_lock when pinning a pagetable") changed xen_pgd_walk to
>> walk over mm->pgd rather than taking pgd as an argument.
>>
>> This breaks xen_mm_(un)pin_all() because it makes init_mm.pgd readonly
>> instead of the pgd we are interested in and therefore the pin subsequently
>> fails.
>>   
>
> Oh, yeah, that was a bit dense.  This is needed for .28.
>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/urgent, thanks guys!

	Ingo
