Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbXFFOVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbXFFOVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXFFOVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:21:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:60143 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbXFFOVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:21:24 -0400
Date: Wed, 6 Jun 2007 16:21:13 +0200 (MEST)
Message-Id: <200706061421.l56ELDfB004305@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, jirislaby@gmail.com
Subject: Re: 2.6.22-rc4-mm1
Cc: htejun@gmail.com, linux-kernel@vger.kernel.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 15:04:00 +0200, Jiri Slaby wrote:
> Andrew Morton napsal(a):
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> 
> It freezes during bootup while searching for sata drives on sata_promise. There
> were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
> unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
> eanother problem? (In this case I'll post dmesg and co.)

I know of only one sata_promise-specific issue in 2.6.22-rc4.
Tejun's "sata_promise: use TF interface for polling NODATA commands"
patch posted today fixes it.

If there are any other sata_promise-specific issues, please
let us know.

/Mikael
