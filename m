Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXBSRvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXBSRvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932439AbXBSRvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:51:48 -0500
Received: from smtp.nokia.com ([131.228.20.172]:65142 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXBSRvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:51:47 -0500
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070219143321.GE25490@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217224952.GB16522@thunk.org> <1171889303.13817.29.camel@sauron>
	 <20070219143321.GE25490@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 19:07:46 +0200
Message-Id: <1171904866.14817.36.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 17:08:03.0271 (UTC) FILETIME=[8405F570:01C75448]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219190544-1EE55BB0-65105C80/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 09:33 -0500, Theodore Tso wrote:
> It made it much, much, MUCH harder to review.  Especially given that
> the documentation was separated from the implementation.  As I looked
> at the implementation, there was no way to look and what it was
> supposed to do without flipping back to a previous e-mail message and
> losing my place.

I will send Build stuff as the last patch next time, thanks, point
taken.

I just used different concept: one looks at declaration and the overall
picture becomes clear because _there is_ documentation. One does not
look at the implementation to grasp picture on surface.

But your point is fair. I assume _programmers_ look in .c first. Users
may always generate a pdf. I will do what you advise.

May be a good compromise would be to have just brief comments at
headers, and full specification at .c. I will think about this, thanks.

> > This reflects the way of my thinking. I see UBI as a set of units with
> > defined interfaces. So I even physically split the interface description
> > into files. I still think it is easier to grasp the architecture this
> > way.
> 
> Speaking as someone who was coming into it cold, it actually made it
> far more difficult.  Your units were too small, so that meant the
> number of interfaces that were created as a result were huge!  (Around
> 20 _sets_ of interfaces, all of which had to be comprehended for what
> should have been a relatively simple set of functionality!)

Why not? Some stuff may probably be merged. _Specific_ advices are
welcome.

> And when you create that many interfaces, it adds inertia to changing
> the interfaces later on, because it's sometimes not clear how many
> users of the interface there really are.  My general rule of thumb is
> that if an interface only has one user, then it may be a good idea to
> combine it with the user of that interface, and then make the
> functions involved be a static, so that it becomes clear the only user
> of that functoin is within that one file.  You can take this too far,
> and to extremes it doesn't work all that well, but the UBI layer has
> gone waaaaaay off the deep end in terms of functional decomposition.

Well... I do not want any flame on this topic. It is about taste,
trade-offs, compromises. It is difficult to provide _objective_ and
killing arguments here. But I will think on this, point taken, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

