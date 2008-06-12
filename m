Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYFLJJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYFLJJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYFLJJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:09:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866AbYFLJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:09:28 -0400
Date: Thu, 12 Jun 2008 02:08:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: repeatable slab corruption with LTP msgctl08
Message-Id: <20080612020846.c77761cd.akpm@linux-foundation.org>
In-Reply-To: <87mylrnj84.fsf@basil.nowhere.org>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
	<20080611233449.08e6eaa0.akpm@linux-foundation.org>
	<20080612010200.106df621.akpm@linux-foundation.org>
	<20080612011537.6146c41d.akpm@linux-foundation.org>
	<87mylrnj84.fsf@basil.nowhere.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 10:35:55 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Doing the same thing on 2.6.26-rc5-mm3, msgctl08 also runs to
> > completion, in 20.9 seconds.  So
> >
> > - it got slower
> 
> That is because it scales itself to the number of available msg queues.
> So with Nadia's patch there are more and it runs slower.
> 
> In fact it seems to start one process per message queue, so perhaps it's 
> just running out of processes or something. Ok it should not segfault.
> 
> BTW a great way to debug slab corruptions with LTP faster is to run with
> a slab thrasher stress module like http://firstfloor.org/~andi/crasher-26.diff
> 

Something like that might be needed.  I ran it again and it took 49
minutes to crash.

