Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYBBR34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYBBR34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYBBR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:29:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYBBR3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:29:46 -0500
Date: Sat, 2 Feb 2008 18:29:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2 of 7] x86: add common mm/pgtable.c
Message-ID: <20080202172921.GA24961@elte.hu>
References: <patchbomb.1201943112@localhost> <3c9aba41ee700a239859.1201943114@localhost> <20080202103030.GA23897@elte.hu> <47A458B1.4050208@goop.org> <20080202134714.GA925@elte.hu> <47A49974.4040504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A49974.4040504@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> Ingo Molnar wrote:
>> oops, i thought i pasted that. It was this:
>>
>> arch/x86/mm/pgtable.c: In function 'pgd_alloc':
>> arch/x86/mm/pgtable.c:213: error: implicit declaration of function 'quicklist_alloc'
>> arch/x86/mm/pgtable.c:213: warning: initialization makes pointer from integer without a cast
>> arch/x86/mm/pgtable.c:218: error: implicit declaration of function 'quicklist_free'
>> arch/x86/mm/pgtable.c: In function 'check_pgt_cache':
>> arch/x86/mm/pgtable.c:233: error: implicit declaration of function 'quicklist_trim'
>>
>> also, config re-attached. (maybe i messed up the previous one)
>
> Still can't reproduce, but it's a simple case of missing headers.

ok, i'll figure it out if/when it happens with your resent queue.

	Ingo
