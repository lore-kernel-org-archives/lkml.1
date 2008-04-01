Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbYDAVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbYDAVNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932398AbYDAVLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:11:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbYDAVLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:11:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Didier Raboud <didier@raboud.com>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Tue, 1 Apr 2008 23:11:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200804010818.59269.didier@raboud.com> <200804010841.45623.didier@raboud.com>
In-Reply-To: <200804010841.45623.didier@raboud.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804012311.16076.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Didier Raboud wrote:
> Le mardi, 1 avril 2008 08.18:57 Didier Raboud, vous avez écrit :
> > Le lundi, 31 mars 2008 23.03:16 Didier Raboud, vous avez écrit :
> > > Le lundi, 31 mars 2008 22.29:20 Rafael J. Wysocki, vous avez écrit :
> > > > On Monday, 31 of March 2008, Didier Raboud wrote:
> > > > > Le lundi, 31 mars 2008 19.36:00 Didier Raboud, vous avez écrit :
> > > > > > Le lundi, 31 mars 2008 19.24:55 maximilian attems, vous avez écrit :
> > > > > > > On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
> > > > > > > <snipp>
> > > > > > >
> > > > > > > > > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two
> > > > > > > > > > successful hibernate/resume cycles.
> > > > > > > > >
> > > > > > > > > Could you please check if the problem is still present if you
> > > > > > > > > boot with acpi_new_pts_ordering kernel command line argument?
> > > > > > > >
> > > > > > > > By the way, I just added acp_new_pts_ordering at the end of the
> > > > > > > > Grub line beginning by "linux (hd0,1)/vmlinuz(...)". Is that
> > > > > > > > correct ?
> > > > > > >
> > > > > > > seems strange you should add it to the kopt line and then kick as
> > > > > > > root update-grub
> > > > > > >
> > > > > > > # kopt=root=/dev/sda1 ro
> > > > > > > it should land
> > > > > > > kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=/dev/sda1 ro
> > > > > >
> > > > > > Well... I'm using Grub2 (grub-pc). I altered the boot option at
> > > > > > boot time but forgot to check /proc/cmdline. Will try again and
> > > > > > report back.
> > > > > >
> > > > > > Regards,
> > > > > >
> > > > > > Didier
> > > > >
> > > > > Hi,
> > > > >
> > > > > I tried again and ensured that /proc/cmdline 's end was
> > > > > acpi_new_pts_ordering . It did work for 2-3 hibernation, but then
> > > > > failed.
> > > >
> > > > Well, there were quite a lot of suspend-related changes between 2.6.24
> > > > and now.
> > > >
> > > > Hmm, do you have CONFIG_USB_SUSPEND set in .config by chance?
> > > >
> > > > Rafael
> > >
> > > I do (Debian default option)... I will build a kernel without it and
> > > retry.
> > >
> > > Didier
> >
> > Hi again.
> >
> > I compiled the same kernel with CONFIG_USB_SUSPEND not set. After 6
> > hibernations, I haven't had a problem for now.
> >
> > Regards,
> >
> > Didier
> 
> Hi again again,
> 
> It hung after the 10th hibernation...
> 
> I wonder if the problem would not be of Debian's uswsusp binary, because tty1 
> tells me that the image is successfully loaded but I just can't act on my box 
> afterwards.

I don't really think so.  s2disk doesn't really do anything that could hang a
machine, except for the console switch maybe ...

> There is a bug open in the Debian BTS requesting a packaging of the new 
> upstream version (0.8) but the maintainer is told to be too busy to handle it 
> for now.
> 
> Don't know...

Can you please test the in-kernel hibernation, then?

Rafael
