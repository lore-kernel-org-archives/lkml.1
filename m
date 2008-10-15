Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYJOV45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYJOV45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYJOV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:56:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbYJOV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:56:45 -0400
Date: Wed, 15 Oct 2008 14:56:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on
 -next?
Message-Id: <20081015145606.2af3baf1.akpm@linux-foundation.org>
In-Reply-To: <20081015174015.GB8663@kroah.com>
References: <20081015174015.GB8663@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 10:40:15 -0700
Greg KH <greg@kroah.com> wrote:

> Just wondering, I know that -next is failing right now, and is a major
> pain to produce, but that seems to be primarily due to all of the
> subsystems merging with Linus right now.

No, I'd say it's primarily due to subsystem maintainers losing
discipline and changing (or compile-time and runtime breaking) other
people's stuff.  This problem appears to have become much worse since
linux-next started.  I suspect Stephen is cleaning up others' trash so
they're producing more of it.

This situation has totally screwed me over, because my tree is so
dependent upon the composite everyone-else tree.  And a large reason
for that dependency is not that I'm carrying patches against other
people's code - it's that they're changing (or breaking) things which
lie outside their area of responsibility.

During Stephen's absence I was forced to try to assemble a
linux-next-like tree locally and that has become much much harder than
it was before linux-next, because all those trees have gone so rampant.

On one day of last week it took me from 10:00AM until 4:00PM just to
get all the patches applied and partially compiling, despite the fact
that I had them all applied and compiling 24 hours beforehand.

> So does it even make sense to try to create a -next during the 2 weeks
> of the major merge window?  It seems to just cause you a whole lot of
> work, that in the end, is mostly unecessary as all of the subsystem
> maintainers are doing the merging themselves as trees move into Linus's
> tree?
> 

It's very useful to me, because my tree is based on everyone else's. 
With no linux-next I'd need to either go back to pulling everyone
else's junk or I'd need to rebase on mainline.

The latter is sorely tempting.  It would save me vast amounts of time
and hair-tearing.  I'd base my tree on mainline and dammit I'd merge
first.  So everyone who has been changing stuff which is outside their
area of responsibility and breaking other people's stuff would get to
see the consequences of their actions instead of Stephen and I bearing
the brunt of it all the time.


I fear we've reached the stage now where people are merrily merging
bright-and-shiny things into their local trees without giving much
thought at all to the consequences for others.

