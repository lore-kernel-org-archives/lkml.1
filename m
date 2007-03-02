Return-Path: <linux-kernel-owner+w=401wt.eu-S2992612AbXCBQyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992612AbXCBQyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992614AbXCBQyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:54:44 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:51049 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992612AbXCBQyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:54:44 -0500
Subject: Re: [PATCH 4/9] swap: Simplify shmem_unuse() usage [optional]
From: Richard Purdie <rpurdie@openedhand.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
In-Reply-To: <Pine.LNX.4.64.0703021631470.11135@blonde.wat.veritas.com>
References: <1172850884.11149.124.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703021631470.11135@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 16:54:35 +0000
Message-Id: <1172854476.11149.147.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 16:44 +0000, Hugh Dickins wrote:
> Definite NAK to this one from me: I'm sorry the optimization confuses
> you, but it's well commented at both ends, and speeds up shmem swapoff
> very significantly e.g. minutes down to seconds.  There may well be a
> less confusing way of achieving the same effect, with another return
> code from shmem_unuse, and some gotos, but I'm not all that keen.

Currently there is only one site its used in but with the changes, you
end up with two. My concern is that the behaviour of that function is
not obvious to anyone new to the code and I suspect something will get
broken at some point due to that, even if comments are there.

I'd have no problem with a different return code and some gotos and/or
improved logic. The changes these patches make might even make that
easier to implement. I'll take another look at it and see if I can find
a nicer patch.

> Your other patches, well, as ever I hope I'll get to look at them,
> but there are so many people, all much quicker than me, playing in
> mm these days...

I'm open to offers... :)

Cheers,

Richard


