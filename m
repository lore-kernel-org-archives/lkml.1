Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXCDDAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXCDDAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 22:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030236AbXCDDAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 22:00:17 -0500
Received: from terminus.zytor.com ([192.83.249.54]:42149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030197AbXCDDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 22:00:16 -0500
Message-ID: <45EA3447.2080504@zytor.com>
Date: Sat, 03 Mar 2007 18:51:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, Dale Martenson <dmartenson@multitech.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       LKML <linux-kernel@vger.kernel.org>, mit-devel@lists.printk.net
Subject: Re: dlopen-like facility for conditional loading of symbols in modules
 (Re: Firmware for new ti_usb_3410_5052 devices)
References: <1172824155.45e7e05b7980e@my.visi.com> <20070303002707.GJ16509@flower.upol.cz> <20070303002957.GA1966@kroah.com> <200703030840.26982.oliver@neukum.org> <20070303133155.GM16509@flower.upol.cz>
In-Reply-To: <20070303133155.GM16509@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> 
> Maybe modules' dlopen() like facility would be better to handle static
> firmware or any other on-demand static data like ID tables etc.?
> 
> I.e. some additional flag for an exported symbol (in a module), that
> this symbol maybe dynamically requested and used. As far as i can see,
> depmod generates static map, unresolved symbols must be in the kernel
> (System.map).
> 

You can do this with request_module() and having your module overwrite a 
hook.

> It will solve problem of having multiple unneeded firmware images if
> driver handles many devices and firmware is allowed to be in the
> kernel. No need in additional secure infrastructure.
> 

This seems like a hacky way to accomplish what request_firmware() does 
clearer!

	-hpa
