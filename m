Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXKYL5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXKYL5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 06:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXKYL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 06:57:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXKYL5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 06:57:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sun, 25 Nov 2007 13:15:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <20071118052036.11B45DBA2@gherkin.frus.com> <20071124223835.ddd5f6e4.akpm@linux-foundation.org>
In-Reply-To: <20071124223835.ddd5f6e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711251315.17989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Andrew Morton wrote:
> On Sat, 17 Nov 2007 23:20:36 -0600 (CST) rct@gherkin.frus.com (Bob Tracy) wrote:
> 
> > Completely reproducible... 2.6.23-rc3 kernel boots, and normal messages
> > are seen on console as far as disks found and partitions on each.  However,
> > once /dev is populated and the boottime scripts attempt to check filesystem
> > status, no partitions on either of the two disks attached to the SCSI
> > controller are seen.  Dropping into a single-user root shell confirms
> > the sudden "blindness": fdisk can't open /dev/sda.
> > 
> > When I reboot on 2.6.24-rc2, everything works normally.
> > 
> > System environment is Debian Etch.  Both 2.6.24-rc2 and -rc3 were built
> > from the respective unaltered kernel.org source trees, using the same
> > kernel configuration modulo saying "no" to CONFIG_SENSORS_I5K_AMB and
> > CONFIG_PID_NS in -rc3.  No problems with -rc3 on a x86 box.
> 
> Could be something change in sysfs.  Please double-check the config
> options, make sure that something important didn't get disabled.
> 
> Failing that, it would be great if you could bisect this down to the
> offending commit.  http://www.kernel.org/doc/local/git-quick.html has help.
> 
> Richard, Ivan: have you seen anything like this?
> 
> Meanwhile, I guess we should track this as another post-2.6.23 regression
> please.

Added to the list, http://bugzilla.kernel.org/show_bug.cgi?id=9457 .

Thanks,
Rafael
