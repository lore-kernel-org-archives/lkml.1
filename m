Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYJQVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYJQVNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYJQVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:12:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbYJQVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:12:56 -0400
Date: Fri, 17 Oct 2008 14:11:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <1224277413.7654.95.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0810171410020.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>  <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>  <20081016.210404.151891223.davem@davemloft.net>  <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
  <1224220339.7654.84.camel@pasglop>  <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org> <1224277413.7654.95.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Benjamin Herrenschmidt wrote:
> 
> I said archs could add themselves to the list who wants smaller
> resources.

But why even _bother_ with crazy resource widths like 16? 

Absolutely nobody wants those, even if they could use it?

So the default is all the wrong way around. Make the defaults the sane 
ones: 04x for IO, and 08x for MMIO, and then see if anybody wants anything 
else. I seriously doubt they do. The whole ".. but but sparc" argument 
seems to be entirely based on the total mis-conception of truncation that 
has no relevance.

		Linus
