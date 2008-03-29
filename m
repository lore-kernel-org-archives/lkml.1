Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbYC2EB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbYC2EB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 00:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYC2EBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 00:01:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:22008 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYC2EBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 00:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dylPInBllEJDuUQSLqJY3Ch37CkM2UOYNlQ2EnLWJ2rBRPYEfZmd2U6Lj+P3jOW2sXcjI4ffGOXBK8iMWm1FiVWiYd3UnZqbEka/gxAxbsqTw3f0PWm8E9ppd7o6cCep7qkTXf2Pde2zUSXtmyLmgc3lFZVk6HAl9plLvnUYmK8=
Subject: Re: [PATCH] jbd/jbd2 NULL noise
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080329035431.GL10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
	 <1206760526.6543.0.camel@brick> <20080329031843.GJ10722@ZenIV.linux.org.uk>
	 <1206761196.6543.2.camel@brick> <20080329034228.GK10722@ZenIV.linux.org.uk>
	 <20080329035431.GL10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 21:01:52 -0700
Message-Id: <1206763312.6543.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:54 +0000, Al Viro wrote:
> On Sat, Mar 29, 2008 at 03:42:28AM +0000, Al Viro wrote:
> 
> > > I did, it went into -mm and on Mar 5 it was taken into the subsystem
> > > tree.
> > 
> > Wait a minute...  where had it been taken?  What subsystem tree for "just
> > about all of fs/"?  
> 
> You've really got me curious.  The latest -mm I can find is 2.6.25-rc5-mm1,
> it's dated Mar 11 and the patches are very much there -
> broken-out/jbd-sparse-warnings-in-revokec-journalc.patch and
> broken-out/jbd2-sparse-warnings-in-revokec-journalc.patch
> resp., all by themselves and not as a part of any subsystem tree.
> 
> Linus, consider the patch upthread withdrawn.
> 
> Al, still morbidly curious about the akpm's scripts and aforementioned
> message...

Not sure which tree, but received this on Feb 27:


The patch titled
     jbd2: sparse warnings in revoke.c, journal.c
has been removed from the -mm tree.  Its filename was
     jbd2-sparse-warnings-in-revokec-journalc.patch

This patch was dropped because it was merged into mainline or a
subsystem tree

The current -mm tree may be found at
http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: sparse warnings in revoke.c, journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/jbd2/revoke.c:177:34: warning: Using plain integer as NULL pointer
fs/jbd2/revoke.c:183:33: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:222:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:222:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:234:3: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:234:3: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:1972:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:1979:33: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:2005:13: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:2012:17: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

