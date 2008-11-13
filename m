Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYKMHfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYKMHfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYKMHfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:35:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55714 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYKMHfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:35:19 -0500
Date: Thu, 13 Nov 2008 08:33:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mathieu Chouquet-Stringer <mchouque@free.fr>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081113073341.GV26778@kernel.dk>
References: <20081109195033.GA1335@mobydick> <20081112184236.GR26778@kernel.dk> <200811122237.03882.rjw@sisk.pl> <200811121357.02233.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811121357.02233.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12 2008, Jesse Barnes wrote:
> On Wednesday, November 12, 2008 1:37 pm Rafael J. Wysocki wrote:
> > On Wednesday, 12 of November 2008, Jens Axboe wrote:
> > > On Wed, Nov 12 2008, Jesse Barnes wrote:
> > > > On Tuesday, November 11, 2008 7:27 am Mathieu Chouquet-Stringer wrote:
> > > > > On Tue, Nov 11, 2008 at 12:15:24AM +0100, Mathieu Chouquet-Stringer 
> wrote:
> > > > > > This one I guess:
> > > > > > http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view
> > > > > >
> > > > > > Let me give it a shot, I'll keep you posted.
> > > > >
> > > > > So I compiled the module, rebooted just to have a clean starting
> > > > > point, started X then tried to suspend: no go...
> > > >
> > > > Dave pushed a fix for this (more complete than the one in the patch you
> > > > reference), have you tried the kernel from today to see if things work
> > > > now?
> > >
> > > A drm enabled kernel also hangs hard on resume (just see the mouse
> > > pointer) here on the x60. Removing drm makes it work just fine. 2.6.27
> > > works fine as well.
> >
> > Is there Intel graphics in there?
> 
> Yeah I think so... I wonder if this is another case where a POST
> conflicted with the kernel's restore and caused X to hang...

Yep, it's intel graphics, sorry I should have mentioned that!

> Jens, does suspend/resume work if you just do it from the console
> (echo mem > /sys/power/state) with i915 loaded?

Let me try that right away.

-- 
Jens Axboe

