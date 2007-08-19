Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbXHSVmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbXHSVmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 17:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXHSVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 17:42:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXHSVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 17:42:05 -0400
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Kay Sievers <kay.sievers@vrfy.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: david-b@pacbell.net, jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       greg@kroah.com
In-Reply-To: <20070819.215751.25908715.anemo@mba.ocn.ne.jp>
References: <200708170902.01260.david-b@pacbell.net>
	 <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
	 <3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
	 <20070819.215751.25908715.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 23:45:50 +0200
Message-Id: <1187559950.4419.79.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18PVdPvvS5QbCo5HWqz2D6xvgg2yTO7Otih+6L
 Ph8YQW7n0zJVuoPaAINSIT+SORwwIXeof3vR9dlJxF2rrOamKY
 TAke7OegDGGAVp/+l2Da4G8juUbvaMk
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-19 at 21:57 +0900, Atsushi Nemoto wrote:
> On Fri, 17 Aug 2007 18:32:19 +0200, "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> > > I guess there are some out-of-tree users of this driver, but fixing
> > > them is really trivial, so I don't think this is a big compatibility
> > > problem.
> > 
> > Again, the only sane solution is to provide MODALIAS="platform:<name>"
> > from the platform bus, and adding the aliases to drivers who support
> > autoloading. Modalias strings are not free-text strings, they are
> > required to be prefixed by the subsystem.
> 
> I guess your objection is to my usage of MODULE_ALIAS, right?

No, I object to the concept of "platform" to disable all uevents by
default, just to work around its MODALIAS misuse. The rest of the kernel
works properly, and userspace has a unified way to handle events and
module loading.
There is absolutely no reason for "platform" to be different and break
all reasonable assumptions of module-init-tools, udev and HAL.

Thanks,
Kay

