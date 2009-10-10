Return-Path: <linux-kernel-owner+w=401wt.eu-S964890AbZJJTTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890AbZJJTTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 15:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbZJJTTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 15:19:04 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7877 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762051AbZJJTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 15:19:03 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=sFIEXyL5ArgA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=1qnUodty1-355zeVaBoA:9 a=K6HJjMrJtAualBt6MdsA:7
 a=I-eQ2UMQZnWJUROYgtQozdTBX8MA:4 a=U62fhAwekXMA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: Ying Chu <gm.ychu@gmail.com>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Sat, 10 Oct 2009 13:18:17 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
Cc: ayan@marvell.com, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-raid" <linux-raid@vger.kernel.org>,
       "linux-scsi" <linux-scsi@vger.kernel.org>
References: <200910091141.52303.tfjellstrom@shaw.ca> <200910100956.19241.tfjellstrom@shaw.ca> <20091010164422.GA8896@linux-dev>
In-Reply-To: <20091010164422.GA8896@linux-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910101318.17785.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat October 10 2009, Ying Chu wrote:
> Hi, Thomas
> 
>  Did you build the dm/md storage with SATA disk drives?

Yes I did. I've got 5 Seagate 7200.12 1TB disks, and two 2TB WD Green drives. 
The last two tests used solely the 5 Seagates though.

> On Sat, Oct 10, 2009 at 09:56:19AM -0600, Thomas Fjellstrom wrote:
> > From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
> > To: linux-kernel <linux-kernel@vger.kernel.org>
> > Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
> > Date: Sat, 10 Oct 2009 09:56:19 -0600
> > Cc: linux-raid <linux-raid@vger.kernel.org>,
> > 	linux-scsi <linux-scsi@vger.kernel.org>
> > X-Mailing-List: linux-scsi@vger.kernel.org
> >
> > On Fri October 9 2009, Thomas Fjellstrom wrote:
> > > Hi,
> > >
> > > I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card)
> > > to work with linux for the past month or so. I've recently just RMAed
> > > my first card, and tested the new one under linux, and I see the same
> > > problems.
> > >
> > > The very first time I made a new array off the controller, formated
> > > (with xfs) and mounted the volume, it seemed to work. ioozone even
> > > seemed to run for a while. Sadly after a few minutes I got a stream of
> > > mvs_abort_task messages in dmesg, and any accesses to the volume, or
> > > any disks connected to the controller lock up.
> > >
> > > After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of
> > > kernel.org, and the volume fails to mount with the same mvs_abort_task
> > > messages.
> > >
> > > I've attached my dmesg log from both attempts. dmesg1 is the first
> > > attempt, dmesg2 is the second attempt on the newer kernel.
> > >
> > > I would really appreciate some help with this.
> >
> > I should also mention that if I attempt to remove any of the drives while
> > the card is in a hung state, the entire machine locks up with the
> > keyboard LEDs blinking.
> >
> > This does seem to be a rather serious error.
> >
> > If there is more I can do to help track down the problems, please let me
> > know. I really need to get this to work (my current array is FULL, and
> > may be showing signs of failure) as soon as possible.
> >
> > I can pretty much wipe and reinstall everything at any point on this
> > machine, update/install new kernels, etc. I just don't have a null modem
> > cable atm to hook up a serial console to capture the errors on OOPSes.
> >
> > Thanks.
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
