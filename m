Return-Path: <linux-kernel-owner+w=401wt.eu-S1763722AbYECBU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763722AbYECBU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 21:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYECBUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 21:20:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760548AbYECBUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 21:20:46 -0400
Date: Fri, 2 May 2008 18:18:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-next@vger.kernel.org, Steven French <sfrench@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, Jan Kara <jack@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, Jens Axboe <jens.axboe@oracle.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>, Christian Zankel <chris@zankel.net>,
       Nicolas Pitre <nico@cam.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080502181808.7de7e1e6.akpm@linux-foundation.org>
In-Reply-To: <481BBBBD.9060709@s5r6.in-berlin.de>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<481BBBBD.9060709@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 May 2008 03:11:25 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Andrew Morton wrote:
> > git-ieee1394: git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git#for-mm
> 
> Stephen pulls linux1394-2.6.git#for-next.
> 
> > Guys, could you please prepare a tree for Stephen and send the details
> > over to him?  Please Cc me also.
> > 
> > Once this has happened, there should be no need to run a separate for-mm
> > branch.  I'll just switch over to using whatever branch linux-next is
> > using.
> 
> -mm is going to become identical in content to -next?

-mm will be (and now is)

origin.patch
linux-next.patch
<other patches>

Where "other patches" includes git trees which aren't in linux-next.

So yes, you should drop #for-mm and add #for-next.

I will pull your #for-next brach daily, but I'll only include it (as
git-ieee1394.patch) if for some reason linux-next.patch needed to be
dropped.

