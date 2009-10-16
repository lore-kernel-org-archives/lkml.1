Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbZJPA3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbZJPA3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbZJPA3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:29:05 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:2151 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbZJPA3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:29:04 -0400
X-Trace: 271180941/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.89.236/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.89.236
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAGZb10pPRVns/2dsb2JhbACBUtc/hDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="271180941"
Date: Fri, 16 Oct 2009 01:28:19 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] swap_info: private to swapfile.c
In-Reply-To: <4AD7ABE7.40105@crca.org.au>
Message-ID: <Pine.LNX.4.64.0910160121240.14004@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150144310.3291@sister.anvils> <4AD7ABE7.40105@crca.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Nigel Cunningham wrote:
> Hugh Dickins wrote:
> > The swap_info_struct is mostly private to mm/swapfile.c, with only
> > one other in-tree user: get_swap_bio().  Adjust its interface to
> > map_swap_page(), so that we can then remove get_swap_info_struct().
> > 
> > But there is a popular user out-of-tree, TuxOnIce: so leave the
> > declaration of swap_info_struct in linux/swap.h.
> 
> Sorry for the delay in replying.

Delay?  Not at all!  Just leave the delays to me ;)

> 
> I don't mind if you don't leave swap_info_struct in
> include/linux/swap.h.

Okay, thanks for the info, that's good.  I won't take it out of swap.h
at this point, I'm finished in that area for now; but it's useful to
know that later on we can do so.

> I'm currently reworking my swap support anyway,

There should be better ways to interface to it than get_swap_info_struct().

> adding support for honouring the priority field. I've also recently
> learned that under some circumstances, allocating all available swap can
> take quite a while (I have a user who is hibernating with 32GB of RAM!),
> so I've been thinking about what I can do to optimise that.

Have fun!

Hugh
