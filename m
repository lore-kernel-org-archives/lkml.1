Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbYBGW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbYBGW6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYBGW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:58:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:10028 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYBGW6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=mlXpHRyUQttMb4YGIY6cEZ8FYSSpYcNTnkB8oFhL2AvUjzLbWKjIK6+nrB7h85IDw+DaKZJXCVrXLQ4bi/9cKDVnvgXo2ewlXVe9EKWkCl3hdjKRR0b1zyCFMIG+bkz98Xj60S+nSfziqI+7wKnIyF+3eb5IKRQwu+0ur1gupZU=
Date: Thu, 7 Feb 2008 16:58:02 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jirislaby@gmail.com, stephen.neuendorffer@xilinx.com,
       grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
       paulus@samba.org, galak@gate.crashing.org, benh@kernel.crashing.org,
       torvalds@linux-foundation.org
Subject: Re: Xilinx: hwicap driver comments
Message-ID: <20080207165802.54269f66@weaponx>
In-Reply-To: <20080207141143.618cc173.akpm@linux-foundation.org>
References: <47AB6552.7040503@gmail.com>
	<20080207124203.147ce300.akpm@linux-foundation.org>
	<20080207153545.14a9c8ed@weaponx>
	<20080207141143.618cc173.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 14:11:43 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 7 Feb 2008 15:35:45 -0600
> Josh Boyer <jwboyer@gmail.com> wrote:
> 
> > > Guys, can we all play too?
> > 
> > Sure.  You could add my tree to -mm if you want.  Though I'd really
> > rather if we all sync up with Paul sooner so you don't have to track 5
> > or 6 "powerpc" trees.
> 
> Yes, I was trying to pull Kumar's tree for a while.  I still am doing so,
> but it's presently 6.5MB of conflicts, so I'll give up on that ;)

Kumar's tree is speshul ;).  I'm entirely too nice and my tree tends to
just be a fast-forward to Paul's most of the time.

> In theory, your 2.6.x+1 material shold be ready to go well in advance of
> the 2.6.x release day (hah), so it'd be good if it could be in Paul's tree
> during 2.6.x's late -rc's.

Actually, 90% of it was.  The recent stuff from my tree was all bug
fixes and/or patches that were waiting on some other subsystem
maintainer to get merged (the ehci usb bits, etc).  I think I'm still
waiting on Jeff for a netdev patch even.  Anyway, the exception to that
was the Virtex stuff so my bad there.

So I really am trying to play nice and mostly have stuff in by the
-rc's already.  I'll take heed to your warning though and watch the
late commits from now on.

josh
