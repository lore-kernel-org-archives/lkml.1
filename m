Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYHASfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYHASfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbYHASdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:33:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179AbYHASdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:33:13 -0400
Date: Fri, 1 Aug 2008 11:32:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: nickpiggin@yahoo.com.au, jens.axboe@oracle.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <E1KOzMt-0003fa-Ah@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0808011131500.3277@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807310957200.3277@nehalem.linux-foundation.org> <E1KOceD-0000nD-JA@pomaz-ex.szeredi.hu> <200808011122.51792.nickpiggin@yahoo.com.au> <E1KOzMt-0003fa-Ah@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Miklos Szeredi wrote:
>
> Subject: mm: dont clear PG_uptodate on truncate/invalidate 
> From: Miklos Szeredi <mszeredi@suse.cz>

Ok, this one I have no problems with what-so-ever. I'd like Ack's for this 
kind of change (and obviously hope that it's tested), but it looks clean 
and I think the new rules are better (not just for this case).

		Linus
