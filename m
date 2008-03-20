Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbYCTCiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbYCTCiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYCTChu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:37:50 -0400
Received: from mylar.outflux.net ([69.93.193.226]:44032 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYCTCht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:37:49 -0400
X-Greylist: delayed 2234 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 22:37:49 EDT
Date: Wed, 19 Mar 2008 19:00:33 -0700
From: Bryce Harrington <bryce@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Message-ID: <20080320015841.GB7206@bryceharrington.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803191648.59400.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-HELO: mylar.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 04:48:59PM -0700, Jesse Barnes wrote:
> On Wednesday, March 19, 2008 4:38 pm Justin Madru wrote:
> > Jesse, do you still think it's a bug in the X server driver instead of
> > the kernel driver (dri I guess)? Because I can trigger the blank screen
> > before the X server even starts. If I press ctr+alt+f1 at the _right_
> > time when the kernel is booting (or I guess when the boot splash is
> > showing) it will instantly blank out. That doesn't seem like something
> > related to X.
>
> Depends on the boot splash program.  I think in some configurations it'll be X
> based, but again Bryce probably knows more here as the Ubuntu X guy. :)

Mmm, well indeed that may be the kernel framebuffer.

Justin, one thing you could try is to set your system to boot up without
starting gdm.  Either do this via /etc/X11/default-display-manager
(comment it out, or set to xdm or something) or bypass it entirely by 
mv /etc/rc3.d/{S30,K30}gdm, and then append '3' to the end of the boot line
in grub.  (Maybe there's a better way to achieve this with upstart, but
my upstart-fu is limited.)

Bryce
