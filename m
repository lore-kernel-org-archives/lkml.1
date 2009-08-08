Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZHHWQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZHHWQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 18:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZHHWQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 18:16:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:44693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZHHWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 18:16:51 -0400
Date: Sat, 8 Aug 2009 15:19:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090808151916.61aab3b2@infradead.org>
In-Reply-To: <20090805182805.GA7534@kroah.com>
References: <20090805171513.GA10443@kroah.com>
	<20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
	<20090805182805.GA7534@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 11:28:05 -0700
Greg KH <greg@kroah.com> wrote:
> > and Arjan (who is doing about the fastest Linux boot anyone has and
> > has better data than anyone else)
> 
> We did this work based on Arjan's work.  It solves a problem that
> Moblin has as well, which is why Novell is using it for their
> Moblin-based images they are shipping.  It makes things go faster,
> with a simpler userspace codepath, and we have the numbers as have
> been previously posted.

Uhm.

> > plus 
> > 
> > > Eric has shown that just making the nodes is 0.06 seconds with
> > > todays sysfs interface, and there is room for improvement,
> 
> A 0.06 speedup is still a speedup, right?  :)

it really is only this much.
Do we need to post the program again that we use to make all dev nodes
based on sysfs ? Including the flexibility to have non-default owners
and permissions?



 
> Seriously, we saw much more than that, about 0.5 what I last
> remember, Kay?

I would find that hard to believe, there isn't 0.5 on the table
any which way you look at it.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
