Return-Path: <linux-kernel-owner+w=401wt.eu-S934531AbXG2T4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbXG2T4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765920AbXG2T4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:56:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:58867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763211AbXG2T4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:56:36 -0400
Subject: Re: [BUG] undefined reference to `kobject_actions'
From: Kay Sievers <kay.sievers@vrfy.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20070729193704.GA27994@flint.arm.linux.org.uk>
References: <20070729193401.GA18225@flint.arm.linux.org.uk>
	 <20070729193704.GA27994@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 21:59:05 +0200
Message-Id: <1185739145.2469.0.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19ACF9NU/nxYO/3Qrz/feUgAjdh0XDjy1UsBNR
 43lCCn/sL9wWOQ2I+slxyQ+hMK8nsoNSK+5LxQhLJXLnjUsKZt
 K0nndZJuh/l1yCCYICj08MZVRsdJ83S
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-07-29 at 20:37 +0100, Russell King wrote:
> On Sun, Jul 29, 2007 at 08:34:01PM +0100, Russell King wrote:
> > Many ARM platforms fail to build with the following:
> > 
> > drivers/built-in.o: In function `store_uevent':
> > hid-input.c:(.text+0x19c4c): undefined reference to `kobject_actions'
> > 
> > It appears that if hotplug is disabled, kobject_actions is ifdef'd
> > away but hid-input still references it.
> 
> What I also meant to say is that it looks like it's caused by
> commit 60a96a59569bab85571d0089682109bd3324e896.
> 
> Presumably if hotplug is disabled, we want store_uevent to be
> removed as well?

Does this patch fix it?
  http://lkml.org/lkml/2007/7/20/143

Thanks,
Kay

