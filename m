Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZC0M0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZC0M0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZC0MZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:25:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55451 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZC0MZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:25:49 -0400
Date: Fri, 27 Mar 2009 13:25:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       torvalds@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [GIT PULL] Microblaze initial pack
Message-ID: <20090327122518.GB23023@elte.hu>
References: <49CC8A41.4060503@monstr.eu> <20090327103032.GA12485@elte.hu> <49CCBA3F.6040703@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CCBA3F.6040703@petalogix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Simek <michal.simek@petalogix.com> wrote:

> > I've also done a (quick) license scan and there's this one file i 
> > found:
> >
> >   arch/microblaze/kernel/hw_exception_handler.S
> >
> >    * Copyright (C) 2004 Xilinx, Inc. All rights reserved.
> >    *
> >    * Xilinx, Inc.
> >    * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
> >    * COURTESY TO YOU.BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
> >    * ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
> >    * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
> >    * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
> >    * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
> >
> > That is an all rights reserved copyrighted file, and i'm not sure 
> > the above constitutes a GPLv2 compatible license. It would be less 
> > ambigious to add what you do in the other places instead, something 
> > like:
> >
> >  * (C) Copyright 2004 Xilinx, Inc.
> >  *
> >  * This program is free software; you can redistribute it and/or modify it
> >  * under the terms of the GNU General Public License version 2 as published
> >  * by the Free Software Foundation.
> >   
> This is no my license. I'll ask a Xilinx guys for permission to change
> it for this file.
> John L, Stephen: Could I change the license as Ingo suggested?

Note that there's a couple of other Xilinx files in the upstream 
kernel tree already that could serve as a template:

 drivers/char/xilinx_hwicap/buffer_icap.c: *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 drivers/char/xilinx_hwicap/buffer_icap.h: *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 drivers/char/xilinx_hwicap/fifo_icap.c: *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 drivers/char/xilinx_hwicap/fifo_icap.h: *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 drivers/char/xilinx_hwicap/xilinx_hwicap.c: *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 drivers/char/xilinx_hwicap/xilinx_hwicap.h: *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"

Those files carry this as-is no-warrantes notice plus also a GPLv2 
notice:

/*****************************************************************************
 *
 *     Author: Xilinx, Inc.
 *
 *     This program is free software; you can redistribute it and/or modify it
 *     under the terms of the GNU General Public License as published by the
 *     Free Software Foundation; either version 2 of the License, or (at your
 *     option) any later version.
 *
 *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
 *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
 *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
 *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
 *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
 *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
 *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
 *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
 *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
 *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
 *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 *     FOR A PARTICULAR PURPOSE.
 *
 *     (c) Copyright 2003-2008 Xilinx Inc.
 *     All rights reserved.
 *
 *     You should have received a copy of the GNU General Public License along
 *     with this program; if not, write to the Free Software Foundation, Inc.,
 *     675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *****************************************************************************/

	Ingo
