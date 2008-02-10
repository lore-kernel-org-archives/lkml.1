Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYBJR7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYBJR7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYBJR73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:59:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:33592 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751404AbYBJR72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:59:28 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18fBgkz9b8fErP/JDH5s2/u4h4OE7Tnwf2LBHGtES
	AiddfbP5xijH5o
Date: Sun, 10 Feb 2008 18:59:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH] Define a NO_GPIO macro to compare against and to use as
 an invalid GPIO
In-Reply-To: <200802091727.42628.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0802101856460.4417@axis700.grange>
References: <Pine.LNX.4.64.0801311624370.8478@axis700.grange>
 <200802081543.42467.david-b@pacbell.net> <Pine.LNX.4.64.0802100053450.7517@axis700.grange>
 <200802091727.42628.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, you convinced me:-) I'll redo the patch. Just one comment:

On Sat, 9 Feb 2008, David Brownell wrote:

> On Saturday 09 February 2008, Guennadi Liakhovetski wrote:
> 
> > And when those platforms share drivers, problems  
> > arise. And the simple and efficient NO_IRQ notion, that would fis those 
> > problems nicely, cannot seem to establish itself.
> 
> Inertia is one of the problems there ... plus, the only
> obvious advantage of "#define NO_IRQ 0" is that it makes
> it easier to be lazy about initialization.
> 
> Plus, changing platforms to use that convention means they
> mostly need to adopt an *unnatural* step of mapping from the
> hardware IRQ numbers (which often start at zero, as they do
> on one system I just ssh'd into) to some "logical" ID.
> Even if you believe that's worthwhile, it's work; and it
> could easily break something.

NO_IRQ doesn't have to be 0. Platforms, where 0 is a valid number can use 
-1, or 256, or whatever they want:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
