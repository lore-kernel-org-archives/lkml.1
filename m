Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYKKVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYKKVCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYKKVCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:02:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbYKKVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:02:06 -0500
Date: Tue, 11 Nov 2008 13:01:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: ieidus@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm@vger.kernel.org, chrisw@redhat.com, avi@redhat.com,
       izike@qumranet.com
Subject: Re: [PATCH 1/4] rmap: add page_wrprotect() function,
Message-Id: <20081111130149.4ee2969c.akpm@linux-foundation.org>
In-Reply-To: <20081111203806.GE10818@random.random>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	<1226409701-14831-2-git-send-email-ieidus@redhat.com>
	<20081111113948.f38b9e95.akpm@linux-foundation.org>
	<20081111203806.GE10818@random.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 21:38:06 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> > > + * set all the ptes pointed to a page as read only,
> > > + * odirect_sync is set to 0 in case we cannot protect against race with odirect
> > > + * return the number of ptes that were set as read only
> > > + * (ptes that were read only before this function was called are couned as well)
> > > + */
> > 
> > But it isn't.
> 
> What isn't?

This code comment had the kerneldoc marker ("/**") but it isn't a
kerneldoc comment.

> > I don't understand this odirect_sync thing.  What race?  Please expand
> > this comment to make the function of odirect_sync more understandable.
> 
> I should have answered this one with the above 3 links.

OK, well can we please update the code so these things are clearer.

(It's a permanent problem I have.  I ask "what is this", but I really
mean "the code should be changed so that readers will know what this is")

> > What do you think about making all this new code dependent upon some
> > CONFIG_ switch which CONFIG_KVM can select?
> 
> I like that too.
