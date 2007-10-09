Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbXJISed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbXJISed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXJISe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:34:26 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41095 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbXJISeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:34:25 -0400
Date: Tue, 9 Oct 2007 14:34:24 -0400
To: Timur Tabi <timur@freescale.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Message-ID: <20071009183424.GG4003@csclub.uwaterloo.ca>
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk> <4706A842.9030507@freescale.com> <20071009174623.GC4003@csclub.uwaterloo.ca> <470BC0D5.70305@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470BC0D5.70305@freescale.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 12:56:37PM -0500, Timur Tabi wrote:
> I'm sure they're correct, my problem is that how can my driver know what 
> they are?

If they are correct, then you should only need to know about byte order
in my experience.

> I was hoping that there would be some compile-time constant I could check 
> that would give me this information.
> 
> Yeah, I read that article some time ago when trying to diagnose the problem 
> I was seeing.  It does explain the point I'm trying to make.  We have a 
> device that's used on two product lines: one ARM-based, and one PowerPC.  
> The ARM is little-endian, and the PowerPC is big-endian.  The device can 
> support little-endian or big-endian data, as long as the bit-order matches 
> the byte-order.
> 
> For now, I'm going to have to assume that they do match.

Well that is certainly the normal way it is done.  I think a few odd
machines had options for doing different bit orders, but the normal
setup is that it matches since that is the simplest layout when trying
to implement bit shifts in hardware.

--
Len Sorensen
