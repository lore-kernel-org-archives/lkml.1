Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbXEVAbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbXEVAbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbXEVAbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:31:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57547 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757163AbXEVAbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:31:08 -0400
Date: Tue, 22 May 2007 01:35:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dave Airlie <airlied@gmail.com>, Jon Smirl <jonsmirl@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Message-ID: <20070522013545.5c269641@the-village.bc.nu>
In-Reply-To: <4652295E.7060305@garzik.org>
References: <200705171423.46748.jesse.barnes@intel.com>
	<9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	<200705210914.22663.jbarnes@virtuousgeek.org>
	<200705210934.58559.jbarnes@virtuousgeek.org>
	<9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	<21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	<4652295E.7060305@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > the kernel, it can be a lot smaller than X and auditable.. sticking
> > the DRI protocol in the kernel is just pointless..
> 
> It is a quite sensible idea.
> 
> The userspace X server SHOULD be running under a non-root user, with 
> appropriate fine-grained privs granted to it.
> 
> "I need root to do graphics" is a myopic, antiquated view of the world.

X server: priviledges below everything, pageable
kernel: priviledges as high as conceivable, non-pageable

So why do you want it in kernel.... security is not the sensible answer
here.

