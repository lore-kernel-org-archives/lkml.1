Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXIPTzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXIPTzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXIPTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:54:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbXIPTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:54:57 -0400
Date: Sun, 16 Sep 2007 21:55:16 +0200
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fujitsu application panel driver (rev3)
Message-ID: <20070916215516.2934abad@oldman.hemminger.net>
In-Reply-To: <200709140130.59732.dtor@insightbb.com>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	<20070907120220.GB3901@ucw.cz>
	<20070912133836.5bc87768@oldman>
	<200709140130.59732.dtor@insightbb.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 01:30:58 -0400
Dmitry Torokhov <dtor@insightbb.com> wrote:

> Hi Stephen,
> 
> On Wednesday 12 September 2007 07:38, Stephen Hemminger wrote:
> > This driver supports the application buttons on some Fujitsu Lifebook laptops.
> > It is based on the earlier apanel driver done by Jochen Eisenger, but
> > with many changes.  The original driver used ioctl's and a separate
> > user space program;  see http://apanel.sourceforge.net/tech.php
> > This version hooks into the input subsystem so that the normal
> > Gnome/KDE shortcuts work without any userspace changes.
> > 
> > The Mail Led is handled via leds class device.
> > 
> 
> Thank you very much for convering the led to led subsystem. I tried
> implementing loadable keymap support in the driver, could you please
> try the patch below and if it still works for you then I will apply
> it to my tree.
> 

Sorry, you are raising the bar for new drivers, higher than existing code.
It is really bad (second system syndrome), if maintainers keep wanting
new code to to more than existing drivers.

Please take driver AS IS. Go ahead and add loadable key map support,
but fix all the other drivers in the tree at the same time that use the existing
interface.

