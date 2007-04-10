Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXDJBkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXDJBkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030300AbXDJBkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:40:51 -0400
Received: from smtp.knology.net ([24.214.63.101]:57562 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030295AbXDJBku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:40:50 -0400
Subject: Re: I give up
From: Dave Dillow <dave@thedillows.org>
To: Dave Jones <davej@redhat.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070410012754.GD1994@redhat.com>
References: <200704091007.58535.gene.heskett@gmail.com>
	 <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr>
	 <461A71FA.40900@zytor.com> <200704091538.44253.gene.heskett@gmail.com>
	 <Pine.LNX.4.61.0704092334410.22295@yvahk01.tjqt.qr>
	 <1176157330.4767.12.camel@dillow.idleaire.net>
	 <20070410012754.GD1994@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Apr 2007 21:40:46 -0400
Message-Id: <1176169246.3193.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 21:27 -0400, Dave Jones wrote:
> On Mon, Apr 09, 2007 at 06:22:10PM -0400, Dave Dillow wrote:
>  > On Mon, 2007-04-09 at 23:35 +0200, Jan Engelhardt wrote:
>  > > On Apr 9 2007 15:38, Gene Heskett wrote:
>  > > >On Monday 09 April 2007, H. Peter Anvin wrote:
>  > > >>Jan Engelhardt wrote:
>  > > >>> dm is on 254 for me.. in opensuse with a 2.6.20 that is. I wonder why
>  > > >>> it even moves around. However, even then, those who use udev and
>  > > >>> device names rather than (major,minor) tuples should not have any
>  > > >>> problem.
>  > > >>
>  > > >>It moves around because someone at some point thought it was a great
>  > > >>idea to assign dynamic majors to core functionality.
>  > > >>
>  > > >What were they smoking, I want some of that!
>  > > 
>  > > Do you actually use udev?
>  > 
>  > udev doesn't help the problem he is having (and he is using it, since he
>  > is using Fedora).
> 
> However, it also doesn't explain what the point is of backing up /dev
> when it's dynamically created.

It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
saves the device and inode numbers from the {,l}stat() call on each file
and decides it is a new file if either number changes from run to run.

You are correct about /dev -- who'd back it up if it is dynamically
created? But that is also not the problem Gene is having.
