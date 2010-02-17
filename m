Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0BQUwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:52:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab0BQUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:52:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pedro Ribeiro <pedrib@gmail.com>
Subject: Re: 2.6.33-rc8 regression on i915: resume from hibernate locks up every 2nd time
Date: Wed, 17 Feb 2010 21:52:39 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com> <201002172111.42511.rjw@sisk.pl>
In-Reply-To: <201002172111.42511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002172152.39255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 February 2010, Rafael J. Wysocki wrote:
> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
> > Hi,
> > 
> > commit 84b79f8d2882b0a84330c04839ed4d3cefd2ff77 (drm/i915: Fix crash
> > while aborting hibernation) introduced two new issues which were not
> > present in 2.6.33-rc7:
> > 
> > - every second resume from hibernate results in a blank screen
> > - the annoying flash at the end of atomic copy/restore during the
> > hibernate process is back (present in kernels < 2.6.33)
> > 
> > The first issue is serious, the second is just an annoyance.
> 
> The second one is an expected price of fixing the aborted hibernation
> regression.
> 
> The first one shouldn't happen, though.
> 
> I'll see if I can reproduce that locally.

No, I can't.

Is the driver compiled directly into the kernel or modular?

Rafael
