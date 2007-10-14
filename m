Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXJNODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXJNODo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 10:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbXJNODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 10:03:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbXJNODf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 10:03:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Suspend Broken (Re: 2.6.23-mm1)
Date: Sun, 14 Oct 2007 16:19:14 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710132033.46423.rjw@sisk.pl> <20071014042641.GA5853@linux.vnet.ibm.com>
In-Reply-To: <20071014042641.GA5853@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141619.15283.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 14 October 2007 06:26, Dhaval Giani wrote:
> On Sat, Oct 13, 2007 at 08:33:45PM +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Saturday, 13 October 2007 19:58, Dhaval Giani wrote:
> > > Hi,
> > > 
> > > I just tried 2.6.23-mm1 and suspend is not working there. automount
> > > refuses to go in the freezer. I've attached dmesg (three attempts to
> > > suspend so it gets a bit big). Suspend works on 2.6.23 and sched-devel.
> > > 
> > > Another funny thing that I've noticed on -mm is that amarok refuses to
> > > load a playlist. It works properly on sched-devel tree. 
> > 
> > Could you please try to find the patch that introduces this issue (using
> > bisection)?
> 
> The winner is freezer-use-wait-queue-instead-of-busy-looping.patch

Thanks.

Hm, interesting.  This patch is not really essential, so it's better to drop
if it causes problems.

Andrew, can you drop it, please?

Greetings,
Rafael
