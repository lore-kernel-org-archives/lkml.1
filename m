Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYGAIZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYGAIZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYGAIZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:25:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYGAIZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:25:03 -0400
Date: Tue, 1 Jul 2008 01:14:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Priority heap infrastructure enhancements
Message-Id: <20080701011414.2f0cccb5.akpm@linux-foundation.org>
In-Reply-To: <485CB652.90801@linux.vnet.ibm.com>
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com>
	<6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com>
	<485CB652.90801@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008 13:35:38 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Paul Menage wrote:
> > On Wed, Jun 18, 2008 at 6:48 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >> Some of the common code has been factored into heap_adjust() a.k.a heapify
> >> in data structures terminology.
> >>
> >> I am sending out this  patch indepedent of the memory controller changes as
> >> they deserve to be reviewed independently.
> >>
> >> One limitation of the current heap_insert() routine is that it does not
> >> insert an element which is greater than the root, when the heap slots
> >> are fully used. I'll work on and review that interface and find a suitable
> >> way to address that issue
> > 
> > How else would you want it to behave? If you have a fixed size heap
> > and it's full, then you have to drop the largest value. (Well, you
> > could in theory drop the smallest value, but there's no quick way to
> > find that.)
> > 
> 
> I would like to be able to drop the smallest value. Since we cannot drop the
> smallest value, dropping a leaf (heap->size) should be sufficiently good enough.
> I want a max heap and losing the root of the heap does not work for me.
> 
> 
> >> Comments, Flames? Please do review closely!
> >>
> >> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Looks fine.
> > 
> > Reviewed-by: Paul Menage <menage@google.com>
> 
> Thanks for the review!
> 

yup, thanks.

I'll duck the patch until we have some code which uses it.  Please
retain Paul's Reviewed-by: for that occasion.

