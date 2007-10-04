Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbXJDTkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbXJDTkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXJDTj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:39:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbXJDTj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:39:57 -0400
Date: Thu, 4 Oct 2007 15:39:40 -0400
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
Message-ID: <20071004153940.49bd5afc@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0710041220010.12075@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com>
	<20071004040004.708466159@sgi.com>
	<200710041356.51750.ak@suse.de>
	<Pine.LNX.4.64.0710041220010.12075@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007 12:20:50 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 4 Oct 2007, Andi Kleen wrote:
> 
> > We've known for ages that it is possible. But it has been always so
> > rare that it was ignored.
> 
> Well we can now address the rarity. That is the whole point of the 
> patchset.

Introducing complexity to fight a very rare problem with a good
fallback (refusing to fork more tasks, as well as lumpy reclaim)
somehow does not seem like a good tradeoff.
 
> > Is there any evidence this is more common now than it used to be?
> 
> It will be more common if the stack size is increased beyond 8k.

Why would we want to do such a thing?

8kB stacks are large enough...

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
