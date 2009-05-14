Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZENV27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZENV27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZENV2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:28:50 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:49889 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753255AbZENV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:28:49 -0400
Date: Thu, 14 May 2009 16:49:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <1242333519.15391.210.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0905141644520.17868@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>  <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>  <alpine.DEB.1.10.0905121708470.14226@qirst.com>  <20090514092909.GG1365@ucw.cz>  <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Dave Hansen wrote:

> The other thing that I find confusing myself is that we're almost never
> at '0 pages free' (which is what I intrinsically think) when we OOM.
> We're just under the watermarks and not apparently making any progress.
> But I don't think we want to say "under the watermarks" in our error
> message.

Hmmm... We could say that there was memory available but the kernel thread
was not allowed to use it. But that would cause more confusion.


> > > I believe message is often correct. What message would you suggest?
> >
> > "Failure to reclaim memory"
>
> The problem I have with that is that it also doesn't tell the whole.
> story.  It's the end symptom when *just* before we OOM, but it doesn't
> characterize the whole thing very well.  It's like saying the Titanic
> sunk because "too much water onboard." :)  It's true, but it
> concentrates a bit too much on the end state.
>
> To me, it's a question of how much information we can get out in a line
> or two on the console.  Is something like this better?

I am all for putting out more information if we can. But we ran reclaim
and it did not work. The Titanic sank because there was too much water
onboard after all. How it got in there (Iceberg, torpedoed by the CIA (oh
it did not yet exist) in retaliation for British misbehavior) would be
good to know. But the message should not suggest increasing the size of
the Titanic because it cannot hold all the incoming water.

>         "Unable to satisfy memory allocation request and not making
>         progress reclaiming from other sources."
>
> We can't exactly go spitting out an entire tutorial in dmesg, but could
> we stick a short URL in there?  Like http://linux-mm.org/OOM perhaps?

Good idea.

