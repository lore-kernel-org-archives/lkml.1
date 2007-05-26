Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbXEZIvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbXEZIvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 04:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXEZIvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 04:51:09 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49956 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751315AbXEZIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 04:51:08 -0400
Date: Sat, 26 May 2007 10:51:01 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] ps3: Preallocate bootmem memory for the PS3 FLASH
 ROM storage driver
In-Reply-To: <1180132539.19517.2.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.62.0705261050140.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.177254000@sonycom.com>
 <1180132539.19517.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007, Benjamin Herrenschmidt wrote:
> On Fri, 2007-05-25 at 10:36 +0200, Geert.Uytterhoeven@sonycom.com wrote:
> > -#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
> > +#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE) || \
> > +    defined(CONFIG_PS3_FLASH_MODULE) ||
> > defined(CONFIG_PS3_FLASH_MODULE)
> 
> As I said multiple times, imho, #ifdef CONFIG_xxx_MODULE in the kernel
> is always a bug.
> 
> You should always be able to build the module out of tree afteward and
> use it on a kernel that didn't have the CONFIG_xxx_MODULE set imho.

I know.

Do you know another way to allocate an aligned chunk of 256 KiB of physically
contiguous memory, possibly a long time after boot up?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
