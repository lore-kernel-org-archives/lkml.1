Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYCaU3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYCaU3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYCaU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:29:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbYCaU3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:29:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Didier Raboud <didier@raboud.com>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 22:29:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200803311936.02517.didier@raboud.com> <200803312022.03190.didier@raboud.com>
In-Reply-To: <200803312022.03190.didier@raboud.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803312229.20712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 31 of March 2008, Didier Raboud wrote:
> Le lundi, 31 mars 2008 19.36:00 Didier Raboud, vous avez écrit :
> > Le lundi, 31 mars 2008 19.24:55 maximilian attems, vous avez écrit :
> > > On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
> > > <snipp>
> > >
> > > > > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful
> > > > > > hibernate/resume cycles.
> > > > >
> > > > > Could you please check if the problem is still present if you boot
> > > > > with acpi_new_pts_ordering kernel command line argument?
> > > >
> > > > By the way, I just added acp_new_pts_ordering at the end of the Grub
> > > > line beginning by "linux (hd0,1)/vmlinuz(...)". Is that correct ?
> > >
> > > seems strange you should add it to the kopt line and then kick as root
> > > update-grub
> > >
> > > # kopt=root=/dev/sda1 ro
> > > it should land
> > > kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=/dev/sda1 ro
> >
> > Well... I'm using Grub2 (grub-pc). I altered the boot option at boot time
> > but forgot to check /proc/cmdline. Will try again and report back.
> >
> > Regards,
> >
> > Didier
> 
> Hi, 
> 
> I tried again and ensured that /proc/cmdline 's end was 
> acpi_new_pts_ordering . It did work for 2-3 hibernation, but then failed.

Well, there were quite a lot of suspend-related changes between 2.6.24 and
now.

Hmm, do you have CONFIG_USB_SUSPEND set in .config by chance?

Rafael
