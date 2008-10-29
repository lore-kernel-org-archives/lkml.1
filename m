Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYJ2VZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYJ2VZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYJ2VZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:25:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbYJ2VZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:25:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pascal Terjan" <pterjan@mandriva.com>
Subject: Re: pm_op(): pci_pm_restore+0x0/0x70 returns -16
Date: Wed, 29 Oct 2008 22:30:07 +0100
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1225190519.8039.14.camel@plop> <200810290018.24479.rjw@sisk.pl> <e8ca35370810281938y38daaa5fo581817264a8959db@mail.gmail.com>
In-Reply-To: <e8ca35370810281938y38daaa5fo581817264a8959db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810292230.07709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 of October 2008, Pascal Terjan wrote:
> On Wed, Oct 29, 2008 at 12:18 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, 28 of October 2008, Pascal Terjan wrote:
> >> Since I updated my laptop (Thikpad T40) to 2.6.27-rc5 and all new
> >> kernels until 2.6.27.3 (was using 2.6.25 before), I get this at resume
> >> time after hibernation :
> >>
> >> Oct 28 10:39:18 plop kernel: pm_op(): pci_pm_restore+0x0/0x70 returns
> >> -16
> >> Oct 28 10:39:19 plop kernel: PM: Device 0000:00:00.0 failed to restore:
> >> error -16
> >>
> >> This may or may not be related to resume issues I often get.
> >>
> >> Sometimes it still work fine, sometimes it panics but I can't get any
> >> log, sometimes I get back to X but without USB mouse, without keyboard
> >> and ssh not responding (sysrq still work).
> >
> > It looks like the ->restore() callback fails for your hostbridge.  It might
> > have done that before, but we've only been reporting such failures since the
> > 2.6.27 development cycle.
> >
> > Did hibernation work correctly with 2.6.25?
> 
> Yes it worked fine
> I hibernate twice a day and never got failures with old kernels while
> it now fails to resume most of the time, but other things have changed
> and I did not do any investigation (for example I switched to libata
> while switching to 2.6.27-rc).
> If this message is only additional reporting, i will try to do some more testing

Yes, this printk() got introduced in 2.6.27.

Thanks,
Rafael
