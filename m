Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZDQWV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZDQWV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZDQWVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:21:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbZDQWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:21:17 -0400
Date: Fri, 17 Apr 2009 15:18:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: randy.dunlap@oracle.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
Message-Id: <20090417151853.6f02d8d3.akpm@linux-foundation.org>
In-Reply-To: <1240006168.31116.62.camel@localhost>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	<20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	<1240003652.31116.44.camel@localhost>
	<20090417144117.4ac8828f.akpm@linux-foundation.org>
	<1240006168.31116.62.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 15:09:28 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2009-04-17 at 14:41 -0700, Andrew Morton wrote:
> > Lots of people's scripts/get_maintainer.pl files won't have the `x' bit
> > set because patch(1) is dumb.  So for reliability it's best to always do
> 
> git at least persisted the "x" bit.
> checkpatch doesn't say to use perl.
> 
> > 	perl ./scripts/get_maintainer.pl
> 
> OK by me.
> 
> > : akpm:/usr/src/25> perl scripts/get_maintainer.pl -f fs/ext3/inode.c 
> > : grep: The -P option is not supported
> >     that's odd.  `man grep' on this machine says
> 
> I changed the script grep to use "-E", which is older.
> 
> > : fatal: Not a git repository
> > 
> >     it whines about not being run in a git directory, but does a decent
> >     job anyway.  
> 
> Oh, I see, you've git installed, but not in your
> /usr/src/25 directory.
> 
> I changed the script to verify that a .git directory
> exists before running git.

hm, well, there's benefit in telling the user "hey, you'll get better
results if you run this in your git directory".

> How about with these 2 patches applied?
> 

akpm:/usr/src/25> perl scripts/get_maintainer.pl -f fs/ext3/inode.c
Andreas Dilger <adilger@sun.com>
Andrew Morton <akpm@linux-foundation.org>
Stephen Tweedie <sct@redhat.com>
linux-ext4@vger.kernel.org
linux-kernel@vger.kernel.org

