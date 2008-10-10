Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbYJJTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbYJJTab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761119AbYJJTaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:30:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856AbYJJTaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:30:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176 suspend_test_finish+0x70/0x80()
Date: Fri, 10 Oct 2008 21:34:26 +0200
User-Agent: KMail/1.9.9
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0810101257030.2185-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810101257030.2185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810102134.27112.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Alan Stern wrote:
> On Fri, 10 Oct 2008, Parag Warudkar wrote:
> 
> > On Fri, Oct 10, 2008 at 10:31 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > There's a bug that affects USB power management: commmit
> > > f9dd45ce10a014bdfd5432828c44630ea7fefedd needs to be reverted.  Greg KH
> > > has been asked to do this a few times but he hasn't gotten around to it
> > > yet.
> > 
> > Hi Alan,
> > 
> > Thanks for the info.
> > 
> > I can't seem to find that commit in mainline. If you have pointer to
> > the patch I will submit a revert.
> 
> It isn't in mainline; it's in linux-next.  Sorry, I wasn't sure which 
> kernel you were using.

I understood it was the mainline from the report.

Parag, could you please try to suspend without the USB drivers and see if the
delay is still there?

Thanks,
Rafael
