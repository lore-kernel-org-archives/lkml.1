Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0CAX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:28:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56385 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0CAX2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:28:34 -0500
Message-ID: <4B8C4CB9.3050901@zytor.com>
Date: Mon, 01 Mar 2010 15:24:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Chris Mason <chris.mason@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] x86/pat changes for v2.6.34
References: <20100227163636.GA10646@elte.hu> <1267468108.16916.937.camel@localhost.localdomain>
In-Reply-To: <1267468108.16916.937.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 10:28 AM, Pallipadi, Venkatesh wrote:
> On Sat, 2010-02-27 at 08:36 -0800, Ingo Molnar wrote:
>> Linus,
>>
>> Please pull the latest x86-pat-for-linus git tree from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-pat-for-linus
>>
>> Please have a look at the lib/rbtree.c changes. The rebalancing changes ought
>> to not impact performance - rb_erase() possibly in a small way. Should this
>> perhaps be done via a separate API entry, instead of modifying existing rbtree
>> code?
>>
>> out-of-topic modifications in x86-pat-for-linus:
>> ------------------------------------------------
>> include/linux/rbtree.h             # 17d9ddc: rbtree: Add support for augmented
>> lib/rbtree.c                       # 17d9ddc: rbtree: Add support for augmented
>>
> These patches should go in before "Add support for augmented rbtrees":
> 
> "btrfs: use RB_ROOT to intialize rb_trees instead of settingrb_node to
> NULL"
> http://lkml.indiana.edu/hypermail/linux/kernel/1002.2/02946.html
> 
> "[patch 0/3] Fixup rb_root initializations to use RB_ROOT"
> http://lkml.indiana.edu/hypermail/linux/kernel/1002.2/03037.html
> 
> 
> 
> And this is an x86 bug fix on top of "Migrate to rbtree only backend for
> pat memtype management"
> http://lkml.indiana.edu/hypermail/linux/kernel/1002.3/00346.html
> 

I have added that the latter patch to tip:x86/pat; Ingo should hopefully
run it through his test machine overnight and bump x86-pat-for-linus.

I feel a bit uncomfortable with the btrfs patches just because they're
out of my area, but I'm Cc:ing Chris to let him either take the patches
or tell me to shut up and just do it ;)

	-hpa
