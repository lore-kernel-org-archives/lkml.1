Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXCDOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXCDOyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbXCDOyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:54:23 -0500
Received: from raven.upol.cz ([158.194.120.4]:56136 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbXCDOyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:54:22 -0500
Date: Sun, 4 Mar 2007 16:03:04 +0100
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, Dale Martenson <dmartenson@multitech.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       LKML <linux-kernel@vger.kernel.org>, mit-devel@lists.printk.net
Subject: Re: dlopen-like facility for conditional loading of symbols in modules (Re: Firmware for new ti_usb_3410_5052 devices)
Message-ID: <20070304150304.GP16509@flower.upol.cz>
References: <1172824155.45e7e05b7980e@my.visi.com> <20070303002707.GJ16509@flower.upol.cz> <20070303002957.GA1966@kroah.com> <200703030840.26982.oliver@neukum.org> <20070303133155.GM16509@flower.upol.cz> <45EA3447.2080504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EA3447.2080504@zytor.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 06:51:51PM -0800, H. Peter Anvin wrote:
[]
> >It will solve problem of having multiple unneeded firmware images if
> >driver handles many devices and firmware is allowed to be in the
> >kernel. No need in additional secure infrastructure.
> >
> 
> This seems like a hacky way to accomplish what request_firmware() does 
> clearer!

(Among other its clear features) after nearly four years being in the
kernel -- i don't think so.

I will try to check request_module(). Maybe this is a hack, but it's way
more supported and bloat-ware independent (:.
____
