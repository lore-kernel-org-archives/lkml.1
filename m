Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbZDGUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbZDGUtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZDGUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:49:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457AbZDGUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:49:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64(HP nx6325), NFS broken
Date: Tue, 7 Apr 2009 22:49:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <49DB69FA.1060202@lwfinger.net> <200904072113.20703.rjw@sisk.pl> <49DBA9D0.7080400@lwfinger.net>
In-Reply-To: <49DBA9D0.7080400@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072249.02211.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 07 April 2009, Larry Finger wrote:
> >> My system also fails to load modules from initrd unless 9cb610d is reverted.
> >> Something is wrong with the "module: remove the SHF_ALLOC flag on the __versions
> >> section" patch.
> > 
> > This is fixed in the current -git, although I had to apply the patch from
> > http://patchwork.kernel.org/patch/16776/
> > to fix an Oops on boot.
> 
> Thanks for the heads-up, particularly on the 16776 patch above. I was in the
> middle of a bisection to isolate that one.
> 
> Do you know anything about a regression that leads to "phy0: Failed to
> initialize wep: -2" messages? It is the 3rd one that I'm chasing and seems to
> affect all wireless drivers. For this one, removing and reinserting the driver
> corrects the problem.

No, I didn't know about this one.  Has it been reported anywhere already?

Rafael
