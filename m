Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXGCA2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXGCA2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXGCA2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:28:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48600 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757342AbXGCA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:28:17 -0400
Date: Tue, 3 Jul 2007 02:28:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Juan Antonio Martinez <jonsito@teleline.es>,
       linux-kernel@vger.kernel.org
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
Message-ID: <20070703002843.GC3492@stusta.de>
References: <1183368129.4967.1.camel@drake.micasa.es> <20070702154753.56d06f10.akpm@linux-foundation.org> <20070702161220.0b151a28.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070702161220.0b151a28.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 04:12:20PM -0700, Randy Dunlap wrote:
> and if that doesn't help, please try this:
> 
> boot with kernel boot options:
> noisapnp pnpacpi=off
> 
> since we have also seen a couple of cases that look like ACPI + PNP
> are mucking up parallel port printers, so maybe they also muck up
> other ppdevs.

Juan Antonio, please send the output of "dmesg -s 1000000" after booting 
and then trying to access your scanner (without the /etc/ieee1284.conf) 
for both 2.6.20 and 2.6.21.

> ~Randy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

