Return-Path: <linux-kernel-owner+w=401wt.eu-S967153AbYCTA1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967153AbYCTA1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760666AbYCSXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:49:09 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:40041 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756725AbYCSXtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:04 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Wed, 19 Mar 2008 16:48:59 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Bryce Harrington <bryce@canonical.com>
References: <47D828BB.2000702@gawab.com> <200803181417.34320.jbarnes@virtuousgeek.org> <47E1A3F1.3020004@gawab.com>
In-Reply-To: <47E1A3F1.3020004@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803191648.59400.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 19, 2008 4:38 pm Justin Madru wrote:
> Jesse Barnes wrote:
> >> I've put in a sync request for this to get updated for hardy.  (It still
> >> will only be in universe, so won't be built automatically with -intel,
> >> but at least users will be able to more easily compile it by hand.)
> >>
> >> Meanwhile, here is a Ubuntu Hardy build of Debian's package:
> >>
> >> http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess-dev_0.
> >>10-1_i386.deb
> >> http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess0_0.10-
> >>1_i386.deb
> >
> > Thanks a lot Bryce, hopefully this will help Justin build the register
> > dumper so we can track down his problem...
> >
> > Jesse
>
> Thanks for all your help so far! Well I tried to install the deb files
> that Bryce created, unfortunately they're dependent on a newer version
> of libc6. I think (_hope_) this is the one in Hardy _because_ that's
> what I'm doing right now; I've decided to upgrade to Hardy. (so sad
> because I have to download _1.5GB_)
>
> Jesse, do you still think it's a bug in the X server driver instead of
> the kernel driver (dri I guess)? Because I can trigger the blank screen
> before the X server even starts. If I press ctr+alt+f1 at the _right_
> time when the kernel is booting (or I guess when the boot splash is
> showing) it will instantly blank out. That doesn't seem like something
> related to X.

Depends on the boot splash program.  I think in some configurations it'll be X 
based, but again Bryce probably knows more here as the Ubuntu X guy. :)

> Anyways maybe it's multiple things, and by upgrading to Hardy it might
> fix it (which would prove that it's not a kernel bug, but some software
> version dependency bug - which would still be good to know).

Good luck with the upgrade...

Jesse
