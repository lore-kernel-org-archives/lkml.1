Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXEEP1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXEEP1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbXEEP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:27:41 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:29287 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbXEEP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:27:33 -0400
Subject: Re: [git pull] Input patches for 2.6.20
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070505060338.GA27713@suse.de>
References: <200702180204.48643.dtor@insightbb.com>
	 <200705030107.44990.dtor@insightbb.com>
	 <alpine.LFD.0.98.0705041806210.3808@woody.linux-foundation.org>
	 <20070505060338.GA27713@suse.de>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 05 May 2007 10:51:48 +0200
Message-Id: <1178355108.17374.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 23:03 -0700, Greg KH wrote:
> > Martin, in the process I noticed that the new file
> > 
> >       arch/s390/kernel/ipl.c
> > 
> > seems to be broken by the same thing after the driver core merge. The fix 
> > _looks_ equally trivial (change *subsys.kset.kobj into just *subsys.kobj), 
> > but I didn't do that trivial thing, because I cannot even test-compile the 
> > end result. So can you give it a quick look, please?
> 
> Martin, Cornelia already sent me (and lkml) a patch to fix this all up
> if you want to just use that instead.

Nod, Cornelia already found and fixed this problem, so it will be easy
for us to correct the code even if it gets broken in the upstream tree
for a short while. So from our perspective just go ahead and pull.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


