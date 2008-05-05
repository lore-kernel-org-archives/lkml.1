Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYEEUBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYEEUBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYEEUAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:00:53 -0400
Received: from mail.skyusermail.com ([77.240.11.49]:2961 "EHLO
	mail.skyusermail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYEEUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:00:52 -0400
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled
	pipe 0
From: Steven J Newbury <steve@snewbury.org.uk>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
Cc: David Airlie <airlied@linux.ie>,
       DRI for Linux <dri-devel@lists.sourceforge.net>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1210013470.3238.6.camel@infinity>
References: <481E5EE6.6090503@gmail.com>
	 <1209975302.26326.263.camel@thor.sulgenrain.local>
	 <1209991916.24777.8.camel@infinity>  <1210013470.3238.6.camel@infinity>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 05 May 2008 19:59:50 +0100
Message-Id: <1210013990.13180.2.camel@infinity>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 19:51 +0100, Steven J Newbury wrote:
> On Mon, 2008-05-05 at 13:51 +0100, Steven J Newbury wrote:
> > On Mon, 2008-05-05 at 10:15 +0200, Michel Dänzer wrote:
> > > On Sun, 2008-05-04 at 21:12 -0400, Miles Lane wrote:
> [snip]
> > > Note that some of these are for pipe 1 as well as pipe 0. Does the
> > > problem only occur for one of them?
> > Miles isn't alone, I also get 'trying to get vblank count for disabled
> > pipe 0' (GM965).  vblank interrupts were previously not working for me,
> > but they are now.  I'm not sure what's changed. 
> OK I know what changed.  The DRM in the kernel has working vblank but it
> still produces the "disabled" warning in the kernel log.  git DRM
> produces ~1 fps with sync to vblank enabled.  Seems the vblank interrupt
> isn't getting enabled in the git DRM, but the warning message is
> actually unrelated.
Actually I had a patch from my previous attempt to fix this still
applied to my git-drm.  Now reverted git-drm is behaving identically to
the linux kernel DRM.  vsync is working but the disabled pipe warning is
produced.

