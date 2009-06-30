Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZF3DtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZF3DtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZF3DtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:49:01 -0400
Received: from kroah.org ([198.145.64.141]:60555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZF3DtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:49:01 -0400
Date: Mon, 29 Jun 2009 20:48:22 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Marc Aurele La France <root@ualberta.ca>,
       "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
       stable@kernel.org, Research.Support@ualberta.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] x86, setup (2.6.30-stable) fix 80x34 and
	80x60 console modes
Message-ID: <20090630034822.GC12373@kroah.com>
References: <alpine.BSO.1.10.0906291746410.14658@fanir.ucs.ualberta.ca> <4A496A0C.809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A496A0C.809@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 06:27:40PM -0700, H. Peter Anvin wrote:
> Marc Aurele La France wrote:
> > As coded, most INT10 calls in video-vga.c allow the compiler to assume EAX 
> > remains unchanged across them, which is not always the case.  This 
> > triggers an optimisation issue that causes vga_set_vertical_end() to be 
> > called with an incorrect number of scanlines.  Fix this by beefing up the 
> > asm constraints on these calls.
> > 
> > Reported-by: Marc Aurele La France <tsi@xfree86.org>
> > Signed-off-by: Marc Aurele La France <tsi@xfree86.org>
> > Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> Note: this is not in upstream since upstream is not affected due to the
> new "BIOS glovebox" subsystem.

So it is a ".30 only" type patch?  Any older kernel versions affected?

thanks,

greg k-h
