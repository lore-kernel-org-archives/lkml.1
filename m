Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbZCSVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbZCSVST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZCSVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:18:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZCSVSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:18:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Wsd90ty/mzUgB+iNgYupB+TzKCr0M6kPcSOcofg+kEkEF2YBGNDsCy9bpeklLdCYI
	dIRF4aGKsUvZsoI8OFb9Q==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903191317220.3030@localhost.localdomain>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <200903200248.22623.nickpiggin@yahoo.com.au>
	 <alpine.LFD.2.00.0903190902000.17240@localhost.localdomain>
	 <200903200334.55710.nickpiggin@yahoo.com.au>
	 <alpine.LFD.2.00.0903190948510.17240@localhost.localdomain>
	 <alpine.LFD.2.00.0903191317220.3030@localhost.localdomain>
Date: Thu, 19 Mar 2009 14:17:57 -0700
Message-ID: <604427e00903191417m2512f0dbl94163093cffce703@mail.gmail.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Ying Han <yinghan@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 1:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 19 Mar 2009, Linus Torvalds wrote:
>>
>> Ahh, so you re-created it? On ext2 only, or is it visible on ext3 as well?
>> I've not even tested - I assumed that I would have to boot into less
>> memory and downgrade my filesystem to ext2, which made me hope somebody
>> else would pick it up first ;)
>
> Oh, btw, can people who see this (Ying Han, Nick and apparently Jan)
> detail their configurations, please? In particular
>
>  - SMP? (CONFIG_SMP and how many cores do you have if so?)
"CONFIG_SMP=y"
the testing machine i was using has 16 cores.

>
>  - PREEMPT (NONE/VOLUNTARY or full preempt?)
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y

>
>  - RCU (CLASSIC/TREE/PREEMPT?)
Not in my .config file.
>
> since those affect the kinds of races we can see a lot.
>
>                        Linus
>
