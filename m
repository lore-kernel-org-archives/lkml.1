Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbXIAM0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbXIAM0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 08:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXIAM0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 08:26:12 -0400
Received: from iona.labri.fr ([147.210.8.143]:50513 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbXIAM0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 08:26:11 -0400
Date: Sat, 1 Sep 2007 14:26:04 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070901122604.GA3251@implementation.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dtor@mail.ru
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr> <20070712191932.GA3947@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070712191932.GA3947@ucw.cz>
Organization: I am not organized
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Thu 12 Jul 2007 19:19:32 +0000, a écrit :
> On Tue 2007-08-21 22:49:51, Samuel Thibault wrote:
> > Hi,
> > 
> > Jan Engelhardt, le Tue 21 Aug 2007 22:42:24 +0200, a écrit :
> > > >- keycodes: even before translation into keysym.
> > > 
> > > They can use the raw xlation for that.
> > 
> > For userland, yes.  This is for kernel modules.
> 
> And should speakup be a kernel module? Why?

Because userland only begins quite late in the boot process, and
userland may hang.

> What is missing? Yes, you may want to do a small kernel module to read
> kernel bootup messages.

That's what it's all about.

Samuel
