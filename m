Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZDGTNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZDGTNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbZDGTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:13:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbZDGTNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:13:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64(HP nx6325), NFS broken
Date: Tue, 7 Apr 2009 21:13:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <49DB69FA.1060202@lwfinger.net>
In-Reply-To: <49DB69FA.1060202@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072113.20703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Larry Finger wrote:
> >On Tue, 2009-04-07 at 00:47 +0200, Rafael J. Wysocki wrote:
> >> Hi,
> >>
> >> Current mainline (commit 22ae77bc7ac115b9d518d5cbc13d39317079b2b0) can't
> >> find the root device (it's handled by statically compiled-in sata_sil) and
> >> generally causes the "invalid module format" message to appear for all modules
> >> loaded from the initrd on my HP nx6325 (the distro is openSUSE 11.1).
> >>
> >> I don't know which commit might have made this happen, but the breakage was
> >> introduced during the last three days (commit
> >> 601cc11d054ae4b5e9b5babec3d8e4667a2cb9b5 is certainly good). I'll bisect
> >> tomorrow if there are no ideas.
> 
> > I bisected "invalid module format" woes to 9cb610d.
> 
> My system also fails to load modules from initrd unless 9cb610d is reverted.
> Something is wrong with the "module: remove the SHF_ALLOC flag on the __versions
> section" patch.

This is fixed in the current -git, although I had to apply the patch from
http://patchwork.kernel.org/patch/16776/
to fix an Oops on boot.

Thanks,
Rafael
