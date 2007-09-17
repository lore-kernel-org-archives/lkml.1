Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbXIQTSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbXIQTSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXIQTSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:18:34 -0400
Received: from www.osadl.org ([213.239.205.134]:45853 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754640AbXIQTSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:18:33 -0400
Subject: Re: Lossy interrupts on x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200709171213.21511.jbarnes@virtuousgeek.org>
References: <200709120833.15980.jbarnes@virtuousgeek.org>
	 <200709120929.52217.jbarnes@virtuousgeek.org>
	 <1189616795.4302.1.camel@chaos>
	 <200709171213.21511.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 21:18:23 +0200
Message-Id: <1190056703.2995.11.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-17 at 12:13 -0700, Jesse Barnes wrote:
> On Wednesday, September 12, 2007, Thomas Gleixner wrote:
> > does it make any difference when you boot the box with:
> >
> > nohz=off
> >
> > on the kernel command line ?
> 
> Yeah, that makes a difference:  the box hangs when I start receiving 
> vblank interrupts instead.  However it's not a hard hang, I think X 
> just becomes unresponsive.  I can still hit the power button on the 
> laptop and the machine shuts down gracefully, but ctl-alt-delete and 
> ctl-alt-backspace don't work.  So X is probably still up and in charge 
> of input but may not be getting any more timeslices or something.

Eeek, that sounds scary. Can you add "highres=off" as well ?

	tglx


