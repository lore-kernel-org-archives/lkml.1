Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZLBVsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZLBVsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZLBVsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:48:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbZLBVsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:48:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Wed, 2 Dec 2009 22:49:07 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <87638qw2zy.fsf@tac.ki.iif.hu> <87skbtve5w.fsf@tac.ki.iif.hu>
In-Reply-To: <87skbtve5w.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912022249.07325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009, Ferenc Wagner wrote:
> Ferenc Wagner <wferi@niif.hu> writes:
> 
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >
> >> On Tuesday 01 December 2009, Ferenc Wagner wrote:
> >>
> >>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >>> 
> >>>> On Tuesday 01 December 2009, Ferenc Wagner wrote:
> >>>>
> >>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >>>>>
> >>>>>> In addition to that, you can run multiple hibernation/resume cycles in
> >>>>>> a tight loop using the RTC wakealarm.
> >>>>> 
> >>>>> I'll do so, as soon as I find a way to automatically supply the dm-crypt
> >>>>> passphrase... or even better, learn to hibernate to ramdisk from the
> >>>>> initramfs. :)
> >>>>
> >>>> Well, you don't need to use swap encryption for _testing_. :-)
> >>> 
> >>> I use partition encryption, everything except for /boot is encrypted.
> >>
> >> If /boot is big enough, you could use a swap file in /boot for the testing.
> >
> > Ramdisk worked good.  Maybe too good, because I left the machine doing
> > s2disks while I was having dinner, and it achieved some 120 suspends
> > without a freeze.  Only the e100 and the mii modules were loaded.
> >
> > After some script munging I got the machine automatically boot with an
> > alternate passphrase, so in vivo testing is possible now.  I mean,
> > tomorrow.
> 
> After almost 100 hibernate/resume cycles, I have to say that this issue
> can't be reproduced by suspending in a tight loop.  I tried that while
> flood pinging my gateway and also with no network activity.  The rc8
> e100 module was loaded all the time.

I wonder if this patch:

http://patchwork.kernel.org/patch/64276/

helps in your case.

Thanks,
Rafael
