Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbXJNEeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbXJNEeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXJNEdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:33:51 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:47694 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXJNEdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:33:50 -0400
Date: Sun, 14 Oct 2007 09:56:41 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz
Subject: Re: Suspend Broken (Re: 2.6.23-mm1)
Message-ID: <20071014042641.GA5853@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071013175845.GA14596@linux.vnet.ibm.com> <200710132033.46423.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710132033.46423.rjw@sisk.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 08:33:45PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Saturday, 13 October 2007 19:58, Dhaval Giani wrote:
> > Hi,
> > 
> > I just tried 2.6.23-mm1 and suspend is not working there. automount
> > refuses to go in the freezer. I've attached dmesg (three attempts to
> > suspend so it gets a bit big). Suspend works on 2.6.23 and sched-devel.
> > 
> > Another funny thing that I've noticed on -mm is that amarok refuses to
> > load a playlist. It works properly on sched-devel tree. 
> 
> Could you please try to find the patch that introduces this issue (using
> bisection)?

The winner is freezer-use-wait-queue-instead-of-busy-looping.patch

-- 
regards,
Dhaval
