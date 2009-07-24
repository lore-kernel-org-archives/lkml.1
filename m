Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZGXXAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZGXXAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZGXXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:00:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbZGXXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:00:18 -0400
Date: Fri, 24 Jul 2009 15:59:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Madhusudhan" <madhu.cr@ti.com>
Cc: adrian.hunter@nokia.com, linus.walleij@stericsson.com,
       linus.ml.walleij@gmail.com, linux-kernel@vger.kernel.org,
       pierre@ossman.eu, linux-arm-kernel@lists.arm.linux.org.uk,
       david.vrabel@csr.com, marek.vasut@gmail.com
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
Message-Id: <20090724155935.22f854f9.akpm@linux-foundation.org>
In-Reply-To: <008801ca0caa$832f9df0$544ff780@am.dhcp.ti.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
	<4A6701E3.3000204@csr.com>
	<63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com>
	<4A68709E.5060207@csr.com>
	<4A68A8D9.1020207@nokia.com>
	<008801ca0caa$832f9df0$544ff780@am.dhcp.ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 17:03:01 -0500
"Madhusudhan" <madhu.cr@ti.com> wrote:

> 
> > -----Original Message-----
> > From: Adrian Hunter [mailto:adrian.hunter@nokia.com]
> > Sent: Thursday, July 23, 2009 1:16 PM
> > To: Linus Walleij
> > Cc: Linus Walleij; Andrew Morton; linux-kernel@vger.kernel.org; Pierre
> > Ossman; linux-arm-kernel@lists.arm.linux.org.uk; David Vrabel;
> > marek.vasut@gmail.com; Madhusudhan Chikkature
> > Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
> > 
> > Hi
> > 
> > Have you considered using our enable/disable approach instead?
> > 
> > It is here:
> > 
> > http://groups.google.com/group/linux.kernel/browse_frm/thread/a5caec1de127
> > 4be5/2ba7dee2a187a268
> > 
> > Perhaps it meets your needs, whereas your patches do not seem
> > to cover the functionality we need.
> > 
>
> The patch #28 "The omap hsmmc driver code refactoring" in the series does
> not seem to apply.

(top-posting repaired - please don't!)

I got one reject when applying that patch, due to
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch.  It was
simple to fix that up.

