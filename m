Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbYBBQ0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbYBBQ0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbYBBQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:26:14 -0500
Received: from gw.goop.org ([64.81.55.164]:40942 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbYBBQ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:26:13 -0500
Message-ID: <47A49974.4040504@goop.org>
Date: Sat, 02 Feb 2008 08:25:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2 of 7] x86: add common mm/pgtable.c
References: <patchbomb.1201943112@localhost> <3c9aba41ee700a239859.1201943114@localhost> <20080202103030.GA23897@elte.hu> <47A458B1.4050208@goop.org> <20080202134714.GA925@elte.hu>
In-Reply-To: <20080202134714.GA925@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> oops, i thought i pasted that. It was this:
>
> arch/x86/mm/pgtable.c: In function 'pgd_alloc':
> arch/x86/mm/pgtable.c:213: error: implicit declaration of function 'quicklist_alloc'
> arch/x86/mm/pgtable.c:213: warning: initialization makes pointer from integer without a cast
> arch/x86/mm/pgtable.c:218: error: implicit declaration of function 'quicklist_free'
> arch/x86/mm/pgtable.c: In function 'check_pgt_cache':
> arch/x86/mm/pgtable.c:233: error: implicit declaration of function 'quicklist_trim'
>
> also, config re-attached. (maybe i messed up the previous one)
>   

Still can't reproduce, but it's a simple case of missing headers.

    J
