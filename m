Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbYEBKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbYEBKry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbYEBKrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:47:47 -0400
Received: from 213.237.47.228.adsl.vbr.worldonline.dk ([213.237.47.228]:19997
	"EHLO rap.rap.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbYEBKrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:47:47 -0400
X-Greylist: delayed 1360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 06:47:46 EDT
Date: Fri, 2 May 2008 12:25:00 +0200
From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>,
       alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs
Message-ID: <20080502102500.GB16198@rap.rap.dk>
References: <1209692359.16523.2.camel@localhost> <73000.21239.qm@web50212.mail.re2.yahoo.com> <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com> <1209696179.16523.13.camel@localhost> <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com> <1209715763.7827.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209715763.7827.2.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:09:23AM +0200, Kasper Sandberg wrote:
> On Fri, 2008-05-02 at 00:06 -0700, David Rees wrote:
> > On Thu, May 1, 2008 at 7:42 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > >  in other words, would i be
> > >  safer to run rsync every day to my other disk, and run in non-raid
> > >  mode?!
> > 
> > What would be safer is to run rsync every day from one redundant array
> > to another array - preferably on another machine that is located as
> > far away as possible from the one that you are backing up.
> > 
> > RAID is not the same as a backup, though unfortunately, too many
> > people treat it as such.
> Im not treating it as a backup, what i want, is to make sure that if 1
> disk dies, the data is still intact and ill hopefully be able to run
> with 1 disk till the newly ordered one arrives - and while i naturally
> will keep offsite backups of most important data, it is certainly far
> easier to simply rip out a faulty disk, and put in another, instead of
> restoring from backup from scratch..
> 
> So my question remains.. Is md raid1 not suited for this need? would it
> be safer to run in non-raid1 mode and daily(maybe hourly) rsync
> everything over to the second disk?

I join in on this question. I have written a howto on our linux raid
page, that exactly advocates a way to with 2 drives use these 2 drives
for multiple partitions, of different types of RAID. The partitions
include /boot / /home and swap - which are actually all allocated 
as RAID partitions on the same 2 drives. See
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

I am trying to advocate that this be a recommended setup for normal
workstations, to for the price of one extra harddisk get additional
safety and performance.

My take is that Linux RAID code is so stable, including in the degarded
mode, that this is robust and stable. However, there are still bugs to
be found, so you can never be 100 % sure. 

Best regards
keld
