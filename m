Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYBJS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYBJS6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYBJS6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:58:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYBJS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:58:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ray Lee" <ray.lee@tapsys.com>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Sun, 10 Feb 2008 19:55:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Mirco Tischler" <mt-ml@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
       "Len Brown" <len.brown@intel.com>, "Pavel Machek" <pavel@suse.cz>
References: <1202664109.8394.19.camel@mtlp> <2c0942db0802100952k3baec233h5adb22dfd795b72b@mail.gmail.com>
In-Reply-To: <2c0942db0802100952k3baec233h5adb22dfd795b72b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101955.38572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 of February 2008, Ray Lee wrote:
> On Feb 10, 2008 9:21 AM, Mirco Tischler <mt-ml@gmx.de> wrote:
> > Hi
> >
> > I think I found a regression in 2.6.24-git. After waking up from suspend
> > 2 ram, the fan of my laptop turns constantly at highest speed. It didn't
> > do this in 2.6.24.
> >
> > I bisected it down to this commit:
> >
> > commit c95d47a868f35cd47643d116a3c680cdaa954df8
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Tue Jan 8 00:05:21 2008 +0100
> >
> >     ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK
> >
> > Reverting it resolves the problem for me, but I can't say if this makes
> > any sense.
> >
> > My machine is a Zepto laptop with Intel Santa-Rosa chipset and I'm
> > running a x86_64 Ubuntu Gutsy.
> 
> I just noticed the same problem. After about ten minutes, it seems
> like all the ACPI events got 'unstuck' -- my screen's backlight went
> up and down a couple of times (and battery/AC indicator flipped a
> couple of times) responding to previous power loss and gain events, I
> think, and the fans dropped down from high speed to low.
> 
> I was chalking it up to another charming bug on my HP nx6125, but if
> someone else is seeing it too...
> 
> I'm on Ubuntu, x86_64, and git as of a couple days ago as well. I
> haven't tried reverting the patch.

I've just sent a patch to Mirco, please test it too.

Thanks,
Rafael
