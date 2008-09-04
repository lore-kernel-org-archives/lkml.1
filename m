Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYIDJyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYIDJyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYIDJx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:53:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYIDJxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:53:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org
Subject: Re: [GIT]: Networking
Date: Thu, 4 Sep 2008 11:58:18 +0200
User-Agent: KMail/1.9.9
Cc: Ayaz Abdulla <aabdulla@nvidia.com>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       tomasw@gmail.com, yi.zhu@intel.com, linville@tuxdriver.com
References: <20080903.161341.239039051.davem@davemloft.net> <200809041025.15277.rjw@sisk.pl> <48BFABE0.6050505@garzik.org>
In-Reply-To: <48BFABE0.6050505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041158.19929.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of September 2008, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 4 of September 2008, David Miller wrote:
> >> From: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date: Wed, 3 Sep 2008 16:24:16 -0700 (PDT)
> >>
> >>> On Wed, 3 Sep 2008, Linus Torvalds wrote:
> >>>> What's so hard to understand about this?
> >>> Here's a simple rule of thumb:
> >>>  - if it's not on the regression list
> >>>  - if it's not a reported security hole
> >>>  - if it's not on the reported oopses list
> >>> then why are people sending it to me?
> >>>
> >>> IOW, if it's just another random improvement, and you send it to me 
> >>> outside of the merge window, then what is the point of the merge window? 
> >> This is exactly what I've been trying to tell the Intel wireless folks
> >> but they refuse to listen.
> >>
> >> I just won't take their stuff until they get their act in gear.
> >>
> >> No problem.
> > 
> > BTW, there are two regression fixes for forcedeth:
> > 
> > http://marc.info/?l=linux-kernel&m=121894389018584&w=4
> > http://marc.info/?l=linux-kernel&m=121917167232014&w=4
> > 
> > that fix the regressions tracked as:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11358
> > http://bugzilla.kernel.org/show_bug.cgi?id=11361
> > 
> > respectively and both are more than 2 weeks old now.
> > 
> > Is there any chance to push them upstream or is there anything wrong with them?
> 
> Your patch is fine.  Since DaveM and I are gone this weekend, feel free 
> to add "acked-by: jgarzik@redhat" and forward upstream to Linus and Andrew.

OK, thanks.

Andrew, this patch is currently in -mm as forcedeth-fix-kexec-regression.patch
Could you please add the Jeff's ACK to it and push it to Linus?

> I thought there was some discussion about Yinghai Lu's MAC addr patch, 
> though.

I see.

> I'll look into it Monday, but maybe Ayaz (maintainer @ nv) could ack it
> sooner than that?

OK, thanks a lot!

Rafael
