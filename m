Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYIYRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYIYRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIYRyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:54:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33812 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYIYRyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:54:08 -0400
Date: Thu, 25 Sep 2008 10:53:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Parag Warudkar <parag.lkml@gmail.com>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-Id: <20080925105320.ef70065b.randy.dunlap@oracle.com>
In-Reply-To: <20080925074923.4845005b.randy.dunlap@oracle.com>
References: <20080924230054.GA27730@suse.de>
	<f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
	<20080925020608.GA13869@suse.de>
	<f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
	<20080925052725.GA5739@linux-sh.org>
	<20080925074923.4845005b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 07:49:23 -0700 Randy Dunlap wrote:

> On Thu, 25 Sep 2008 14:27:26 +0900 Paul Mundt wrote:
> 
> > On Wed, Sep 24, 2008 at 10:59:03PM -0400, Parag Warudkar wrote:
> > > On Wed, Sep 24, 2008 at 10:06 PM, Greg KH <gregkh@suse.de> wrote:
> > > > No, this is much different from EXPERIMENTAL.  That flag is pretty much
> > > > useless right now.  This is for a temporary landing place for drivers
> > > > that are not good enough to be merged, yet are useful enough for some
> > > > people to use.
> > > 
> > > How? TAINT_EXPERIMENTAL (I'll stick to that, thanks :) and
> > > CONFIG_EXPERIMENTAL are no different - neither to users nor to
> > > developers. Here is why -
> > > Both try to do the same thing - let people use the drivers on their
> > > own risk (as if the stable ones are developer's risk - but let's keep
> > > it aside for the moment) and give developers a chance to keep the code
> > > in sync with mainline and improve it per user problem reports or
> > > generally make it better.
> > > 
> > Uhm.. not quite. As the one that proposed the flag in the first place,
> > perhaps it helps to cover the rationale (although Greg seems to have
> > mostly covered that already).
> > 
> > EXPERIMENTAL today is pretty damn meaningless. What it tends to mean in
> 
> then it would be better if Greg/someone cleaned up the current tree's
> problems instead of introducing more CRAP under a different name.
> Oh well, his mind is already made up and I know how difficult it is to
> change it.

I shouldn't have said that last sentence.  I apologize to Greg.

ISTM that the real problems are (a) it's easier to introduce new staging/crap
than it is to fix EXPERIMENTAL and (b) no one wants to try to fix EXPERIMENTAL.


---
~Randy
