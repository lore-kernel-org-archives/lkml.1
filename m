Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYCBTG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYCBTG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYCBTGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:06:48 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44759 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYCBTGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:06:47 -0500
Date: Sun, 2 Mar 2008 21:05:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: why is CONFIG_PCI unset ? [was: build #350 issue for
	v2.6.25-rc1 in drivers/i2c/busses/i2c-i801.c]
Message-ID: <20080302190515.GA25484@cs181133002.pp.htv.fi>
References: <200802222143.38643.toralf.foerster@gmx.de> <20080222205855.GA7711@uranus.ravnborg.org> <200803021851.34398.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803021851.34398.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 06:51:31PM +0100, Toralf Förster wrote:
>...
> I hard coded my script to prepend these 2 lines
> CONFIG_PCI=y
> CONFIG_I2C=y
> at top of the each .config file before I run "make oldconfig" however the
> resulting config CONFIG_PCI is very often unset.
>...

Why are you doing the "<tweak config file> && make oldconfig" steps at all?

Shouldn't KCONFIG_ALLCONFIG do what you want?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

