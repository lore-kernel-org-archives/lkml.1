Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXGRJYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXGRJYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXGRJXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:23:54 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:45970 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbXGRJXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:23:53 -0400
Date: Wed, 18 Jul 2007 12:23:51 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: dean gaudet <dean@arctic.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, dave@thedillows.org
Subject: Re: [RFT][PATCH v7] sata_mv: convert to new EH
Message-ID: <20070718092351.GY4106@edu.joroinen.fi>
References: <20070711200538.GA7374@havoc.gtf.org> <Pine.LNX.4.64.0707120212210.25837@twinlark.arctic.org> <46960225.5000502@garzik.org> <Pine.LNX.4.64.0707121140560.29365@twinlark.arctic.org> <46967B3C.708@garzik.org> <Pine.LNX.4.64.0707121323570.29365@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707121323570.29365@twinlark.arctic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 07:15:26PM -0700, dean gaudet wrote:
> On Thu, 12 Jul 2007, Jeff Garzik wrote:
> 
> > dean gaudet wrote:
> > > On Thu, 12 Jul 2007, Jeff Garzik wrote:
> > > 
> > > > dean gaudet wrote:
> > > > > oh very nice... no warnings on boot, and no warnings while i "dd
> > > > > if=/dev/sdX
> > > > > of=/dev/null" and i'm seeing 74MB/s+ from each disk on this simple read
> > > > > test.
> > > > > 
> > > > > for lack of a better test i started an untar/diff stress test on the
> > > > > disks... we'll see how it goes.  (it's based on doug ledford's
> > > > > memtest.sh)
> > > > Thanks for the testing.  Looks like we might have hit on something good...
> > > 
> > > yep this does look good.  no problems overnight in the untar/diff/rm
> > > workload.  if you've got any other workload you'd like me to throw at it,
> > > let me know.  i might be able to scare up a disk or two with errors to check
> > > error handling.
> > 
> > Nothing specific.  I usually just throw various workloads at it, both
> > throughput-intensive, seek-intensive, multiple threads at the same time,
> > stressing multiple disks at the same time, etc.
> 
> yeah the untar/diff/rm workload is seek/thread intensive.
> 
> 
> > I presume from your past messages your tests include multiple disks at the
> > same time?
> 
> yep, 4 disks... i was getting 4x74MB/s with dd read.  unfortunately i 
> don't have more disks in the system at this point so i can't test all 8 
> ports at full tilt.
> 
> each disk had its own XFS filesystem.
> 

Hi!

What brand/model your sata_mv controller is? Would be nice to know to be
able to get a "known-to-work" one.. 

-- Pasi
