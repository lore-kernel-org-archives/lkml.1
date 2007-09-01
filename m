Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXIAMvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXIAMvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 08:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXIAMv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 08:51:26 -0400
Received: from iona.labri.fr ([147.210.8.143]:50584 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXIAMvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 08:51:25 -0400
Date: Sat, 1 Sep 2007 14:51:20 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070901125120.GC3251@implementation.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dtor@mail.ru
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr> <20070712191932.GA3947@ucw.cz> <20070901122604.GA3251@implementation.famille.thibault.fr> <20070901123258.GA4612@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070901123258.GA4612@ucw.cz>
Organization: I am not organized
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pavel Machek, le Sat 01 Sep 2007 12:32:58 +0000, a écrit :
> > > > > They can use the raw xlation for that.
> > > > 
> > > > For userland, yes.  This is for kernel modules.
> > > 
> > > And should speakup be a kernel module? Why?
> > 
> > Because userland only begins quite late in the boot process, and
> > userland may hang.
> 
> Initrd means userland is started very early on most machines these
> days, and kernel may hang, too.

Very early is not so early, and loading initrd itself may actually fail.
The kernel may indeed hang, but there are more chances to get some
messages before the hang.  Don't _you_ have a VGA screen for getting
earliest failure messages from the kernel?

> > > What is missing? Yes, you may want to do a small kernel module to read
> > > kernel bootup messages.
> > 
> > That's what it's all about.
> 
> But this small module should not need keyboard leds support, as those are not used during
> boot. If all you want is to read kernel bootup messages, you should
> just register a special console. Actually serial console should do.

The problem is that using both a tool for early message and for later
messages is not particularly handy, that's why speakup is actually
used by people both for boot time and afterwards.  People are indeed
considering moving speakup into userland, but some people still _need_
speakup in the kernel for their everyday work.  Having two versions of
speakup (user and kernel) is just asking for more maintain work, and it
happens that speakup already doesn't have many people involved...

Samuel
