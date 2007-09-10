Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXIJWhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXIJWhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbXIJWg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:36:59 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:46497 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932714AbXIJWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:36:58 -0400
Date: Tue, 11 Sep 2007 00:38:18 +0200
From: aherrman@arcor.de
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] radeonfb: add PCI Id for	RS482/Radeon Xpress 200M
Message-ID: <20070910223818.GC5155@devil>
References: <20070904105831.GE7320@devil> <1188913512.5972.147.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188913512.5972.147.camel@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 03:45:12PM +0200, Benjamin Herrenschmidt wrote:
> On Tue, 2007-09-04 at 12:58 +0200, aherrman@arcor.de wrote:
> > .. which can be found in Acer Aspire 5100.
> > 
> > Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Sorry, I have missed that 0x5975 was already defined for radeonfb.
So this patch shouldn't be applied.

We have already:

        /*Mobility Xpress 200 */
        CHIP_DEF(PCI_CHIP_RS485_5975,   R300,   CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),

This was introduced with commit b5f2f4d1a6d7efde39cfb5e1d034981c69f2214c

But obviously this is not correct as the 0x5975 is an RS48x not R300.
With the current git (w/o my patch) my display goes blank (or better it looks striped)
and the Laptop hangs.

I'll do some further tests on my Laptop and probably come up with a new patch.


Regards,

Andreas

