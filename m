Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbXLINrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbXLINrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXLINrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:47:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXLINrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:47:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gabriel C <nix.or.die@googlemail.com>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: usb regression in 2.6.24-rc4
Date: Sun, 9 Dec 2007 15:05:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200712090113.57805.gene.heskett@gmail.cm> <475B9978.3080606@googlemail.com>
In-Reply-To: <475B9978.3080606@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091505.51233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Gabriel C wrote:
> Gene Heskett wrote:
> > Greetings guys & gals;
> 
> Hi ,
> 
> > 
> > This was sent about an hour ago to the usb-devel list also.
> > -------------
> > Just a few minutes ago I needed to make use of my scanner, an Epson 1250u.
> > 
> > Firing up xsane, the usual select the device menu window didn't show, and it 
> > went straight to my tv card as the only input device.
> > 
> > I couldn't recall the name of the tool that scans for scanners that's in the 
> > sane package, or should be, so I then did an lsusb, but got an empty result!
> > 
> > Unplugging the usb cable from the scanner, then reconnecting the usb cable got 
> > me the usual disconnect and connect messages in the log, but xsane still 
> > couldn't find it.
> > 
> > So I rebooted to 2.6.24-rc4 again, same result.  lsusb still gave an empty 
> > result.  The two kernels were generated from the same .config as far as I 
> > know.  The -rc3 .config was fed to a "make oldconfig" to make 
> > the -rc4 .config as is the usual practice.
> > 
> > So I then rebooted to 2.6.24-rc3, and it all works again.  I got the scanning 
> > done and the pix sent on their merry way.
> > 
> > Anybody have a suggestion of what to check, or maybe a patch to revert?  Or 
> > a .config option that needs to be enabled?
> >
> 
> Sounds for me like this one : 
> 
> http://lkml.org/lkml/2007/12/6/409

Yes, http://bugzilla.kernel.org/show_bug.cgi?id=9504 .

Gene, please try the patch at http://lkml.org/lkml/2007/12/7/364

Thanks,
Rafael
