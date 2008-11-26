Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYKZOJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYKZOJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYKZOJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:09:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36001 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbYKZOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:09:14 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print oops dumps
From: Andi Kleen <andi@firstfloor.org>
References: <20081123130042.1d194768@infradead.org>
	<20081126072445.GG26036@elte.hu>
	<20081126001234.19c9a7b0.akpm@linux-foundation.org>
Date: Wed, 26 Nov 2008 15:09:19 +0100
In-Reply-To: <20081126001234.19c9a7b0.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 26 Nov 2008 00:12:34 -0800")
Message-ID: <874p1ud1f4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 26 Nov 2008 08:24:45 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
>> >  scripts/markup_oops.pl |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 files changed, 162 insertions(+), 0 deletions(-)
>> >  create mode 100644 scripts/markup_oops.pl
>> 
>> looks useful - Andrew, Sam, any objections to this?
>
> who-me-no-i-already-merged-it.
>
> I didn't test it though - I don't have particularly high hopes given
> the general deadness of `make mm/memory.lst' for the past numerous
> years.

make mm/memory.lst should work again with latest binutils. The problem
earlier was that objdump -S was incompatible with unit-at-a-time
mode in gcc, but I fixed that and the binutils maintainers included
the patch.

-Andi

-- 
ak@linux.intel.com
