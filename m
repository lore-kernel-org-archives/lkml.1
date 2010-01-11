Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629Ab0AKWV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0AKWV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667Ab0AKWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:21:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab0AKWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:21:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julien Cristau <jcristau@debian.org>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS
Date: Mon, 11 Jan 2010 23:22:14 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <201001090045.33784.rjw@sisk.pl> <201001112204.36724.rjw@sisk.pl> <20100111214355.GA11456@radis.liafa.jussieu.fr>
In-Reply-To: <20100111214355.GA11456@radis.liafa.jussieu.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112322.14152.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Julien Cristau wrote:
> On Mon, Jan 11, 2010 at 22:04:36 +0100, Rafael J. Wysocki wrote:
> 
> > Hmm, are you trying to say radeon is better at that?
> > 
> > My experience is quite the opposite to be honest.
> > 
> radeon kms is in staging, doesn't pretend to be stable and force all
> users to the experimental paths.  So yes, I would say radeon is better
> at that.

I guess I should have been more precise.

All of my test boxes with ATI/AMD graphics hardware regressed after upgrading
from openSUSE 11.1 to openSUSE 11.2, in different ways, because of the user
space part of the radeon driver.  Of course, you can argue that the dristro
picked up particularly bad release of the driver, but from the user's point of
view it actually doesn't matter whether the breakage is in the kernel part or
in the user space part of the driver.  The difference is, however, that the
breakage in the kernel is fixed _way_ faster than the breakage in the user
space, so I very much prefer the Intel people pushing new features aggressively
and fixing bugs related to that, then the situation where I need to deal with
the broken user space driver, while the KMS radeon is still not reliable
enough.

IOW, if your user space driver worked 100% of the time, I'd totally agree, but
that's not the case, at least as far as I see it.

Rafael
