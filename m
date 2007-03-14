Return-Path: <linux-kernel-owner+w=401wt.eu-S1750938AbXCNQDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbXCNQDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXCNQDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:03:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43036 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXCNQDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:03:08 -0400
Date: Wed, 14 Mar 2007 16:02:58 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
Message-ID: <20070314160258.GK4095@ftp.linux.org.uk>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk> <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 10:50:16AM +0100, Geert Uytterhoeven wrote:
> On Wed, 14 Mar 2007, Al Viro wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> NAK
> 
> There are several problems with making it modular. I did try, cfr. the
> incomplete patchlets below.

[snip]

> And finally, make sure CONFIG_LOGO=n, as there's a bug in the logo code: logos
> are __initdata but the logo code still tries to draw them for a modular fbdev.
> Originally (eons ago) this case was handled by the flag initmem_freed, which no
> longer exists.

Lovely...  Consider that one withdrawn, please.  FWIW, if we leave it bool
(and flip_ctl mess alone would make a good reason for that) we probably want
to have it depend on FB=y
