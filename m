Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbXIZPPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbXIZPPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbXIZPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:15:14 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:18163 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761025AbXIZPPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:15:12 -0400
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 11:15:12 EDT
Date: Wed, 26 Sep 2007 10:03:29 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926150329.GA1563518@hiwaay.net>
References: <fa.1U6+49SWHSlhuK5/3PBckFWAbXU@ifi.uio.no> <fa.WASh5K8oOF4DAq3sSYtIlWNCdWQ@ifi.uio.no> <fa.X6MeYG+PmN8/e5zfGij80quLaws@ifi.uio.no> <fa./eIdqiAY0Mx9xHl6ESobHaLKJBM@ifi.uio.no> <fa.z0K2lB1PTgYQg4l+8PssE1hFZY8@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926151040.2d922706@the-village.bc.nu>
User-Agent: Mutt/1.4i
Original-References: <20070926151040.2d922706@the-village.bc.nu> <46F0CD96.9030807@prepere.com> <20070919104018.3a6bcfb1@the-village.bc.nu> <46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926122127.74cdd000@the-village.bc.nu> <46FA40F3.8010306@davidnewall.com> <20070926123833.2ed598af@the-village.bc.nu> <46FA48FC.4030602@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Alan Cox  <alan@lxorguk.ukuu.org.uk> said:
>Well if citing standards documents at people is rudeness so be it.

I hate to get involved in this, but actually chroot() is no longer part
of SuS as of version 3.

For other Unix versions, both Tru64 (5.1B) and Solaris (9) chroot(2) man
pages also say the working directory is unaffected by chroot().  The
Solaris man page explicitly mentions using fchdir() to reset the root to
a previously opened directory however.

On Tru64 and Solaris, the chroot command does call chdir() after
chroot(), but that is a userspace thing.
