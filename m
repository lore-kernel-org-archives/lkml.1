Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXK0FjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXK0FjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXK0FjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:39:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45041 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbXK0FjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:39:06 -0500
Date: Mon, 26 Nov 2007 21:38:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: bdupree@techfinesse.com, linux-kernel@vger.kernel.org
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
Message-ID: <20071126213847.4768b1f2@laptopd505.fenrus.org>
In-Reply-To: <474B9EC1.5020304@shaw.ca>
References: <fa.c70Wy8WHP3DOaDydQ2D94+Xxx/8@ifi.uio.no>
	<474B9EC1.5020304@shaw.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 22:36:17 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> bdupree@techfinesse.com wrote:
> > Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU
> > on an idle system? The problem occurs if I config the kernel with
> > tickless support (i.e. CONFIG_TICK_ONESHOT=y).  (Thanks to
> > "oprofile" for putting me onto this.)
> > 
> > I have noted this same problem on kernel versions: 2.6.23.1,
> > 2.6.23.8 and 2.6.23.9
> > 
> > **************************************************************************
> > *** Output from "vmstat -n 1 10" -- Note very high context switch
> > rate *** *** This is on a idle
> > machine!                                         ***
> > **************************************************************************
> > 
> > procs -----------memory---------- ---swap-- -----io---- --system--
> > ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs
> > us sy id wa
> >  0  0      0 1925556   4768 116104    0    0   124     2    6
> > 7538  1  2 96  1
> >  0  0      0 1925556   4768 116104    0    0     0     0    2
> > 147329  0  1 99  0
> 
> What did oprofile show? It should be able to narrow down what 
> function(s) are responsible for the CPU usage..
> 

or better, what does powertop version 1.9 show?
that tends to show tickless wakeup artifacts quite nicely


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
