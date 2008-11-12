Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYKLSoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYKLSoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYKLSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:44:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41287 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYKLSoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:44:14 -0500
Date: Wed, 12 Nov 2008 19:42:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mathieu Chouquet-Stringer <mchouque@free.fr>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081112184236.GR26778@kernel.dk>
References: <20081109195033.GA1335@mobydick> <20081110231524.GA18971@mobydick> <20081111152736.GA28569@mobydick> <200811121033.58840.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811121033.58840.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12 2008, Jesse Barnes wrote:
> On Tuesday, November 11, 2008 7:27 am Mathieu Chouquet-Stringer wrote:
> > On Tue, Nov 11, 2008 at 12:15:24AM +0100, Mathieu Chouquet-Stringer wrote:
> > > This one I guess:
> > > http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view
> > >
> > > Let me give it a shot, I'll keep you posted.
> >
> > So I compiled the module, rebooted just to have a clean starting point,
> > started X then tried to suspend: no go...
> 
> Dave pushed a fix for this (more complete than the one in the patch you 
> reference), have you tried the kernel from today to see if things work now?

A drm enabled kernel also hangs hard on resume (just see the mouse
pointer) here on the x60. Removing drm makes it work just fine. 2.6.27
works fine as well.

It's really hard to bisect, since there have been several 'suspend is
broken' points in the current 2.6.28-rc cycle...

-- 
Jens Axboe

