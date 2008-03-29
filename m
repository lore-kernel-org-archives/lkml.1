Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYC2FND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYC2FND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 01:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYC2FMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 01:12:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:25805 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYC2FMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 01:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ukMxE2CyfJWxibg4ilUUu6sXGXz69dTf6P7K/8D7SRiGbn7ZjHoZvtVU9W0qdyNoD1tP2T7IydhL0GjQCLi/uxtAbNmfAENd4zwfWyKhMxaGsTcOdwpo2uO9dbeKA9K9iY7agokRXXxlzWY/RSpT7dJ2ZVHk1LEe+t0fGyIsKyA=
Subject: Re: [PATCH] jbd/jbd2 NULL noise
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080329045634.GM10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
	 <1206760526.6543.0.camel@brick> <20080329031843.GJ10722@ZenIV.linux.org.uk>
	 <1206761196.6543.2.camel@brick> <20080329034228.GK10722@ZenIV.linux.org.uk>
	 <20080329035431.GL10722@ZenIV.linux.org.uk> <1206763312.6543.4.camel@brick>
	 <20080329045634.GM10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 22:12:56 -0700
Message-Id: <1206767576.6543.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 04:56 +0000, Al Viro wrote:
> On Fri, Mar 28, 2008 at 09:01:52PM -0700, Harvey Harrison wrote:
> > > > > I did, it went into -mm and on Mar 5 it was taken into the subsystem
> > > 
> > > Al, still morbidly curious about the akpm's scripts and aforementioned
> > > message...
> > 
> > Not sure which tree, but received this on Feb 27:
> > 
> > 
> > The patch titled
> >      jbd2: sparse warnings in revoke.c, journal.c
> > has been removed from the -mm tree.  Its filename was
> >      jbd2-sparse-warnings-in-revokec-journalc.patch
> > 
> > This patch was dropped because it was merged into mainline or a
> > subsystem tree
> > 
> > The current -mm tree may be found at
> > http://userweb.kernel.org/~akpm/mmotm/
> 
> Ah...  jbd part of it is still there, jbd2 is *also* there, but it's got
> ext4-mm- prefix to filename.  And looking at ext4.git, jbd2 side of that
> stuff *is* merged, so what the hell is it doing in a separate file?
> Looks like -mm has ext4 stuff not as a single patch (like it does for
> many other git trees) but split into individual changesets for some
> reason...
> 
> Anyway, as long as this stuff gets eventually merged...

I'll go through your patches in the morning and see if you've changed
anything that my patches didnt't (referring to you NULL noise patches).

I think I also did the drivers/media stuff, but I will look through it
all tomorrow.

Harvey

