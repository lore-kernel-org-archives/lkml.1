Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXIVJTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXIVJTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXIVJTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:19:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50230 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXIVJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:19:07 -0400
Date: Sat, 22 Sep 2007 14:51:54 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
In-Reply-To: <20070918191740.GC11083@kroah.com>
Message-ID: <alpine.LFD.0.999.0709221433160.28693@enigma.security.iitk.ac.in>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <46EF96CC.1080807@linux.vnet.ibm.com> <20070918022739.f25c2846.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0709181504030.21091@enigma.security.iitk.ac.in>
 <20070918191740.GC11083@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,


On Tue, 18 Sep 2007, Greg KH wrote:
> 
> On Tue, Sep 18, 2007 at 03:04:48PM +0530, Satyam Sharma wrote:
> > 
> > But wait ... isn't that a statically-allocated kobject, which were
> > supposed to be "naughty" in the first place?
> 
> Yes it is, if you want to dynamically create it, please do.

Sorry for being late to reply, but do you still want such a patch (i.e.
convert static to dynamic allocation)?

I read elsewhere on this thread that you'd merge Kamalesh's patch and
fix it up to also use kobject_name() yourself. But it's a small/trivial
driver, so I think just converting it to dynamic allocation right now
itself (when we've noticed it already) is probably better (?)

[ BTW I don't see the fix in your git trees or quilt queue. So I'll
  make a patch on top of 2.6.23-rc6-mm1 itself. ]


Thanks,

Satyam
