Return-Path: <linux-kernel-owner+w=401wt.eu-S1765025AbXHJKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765025AbXHJKuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXHJKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:50:04 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1128 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbXHJKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:50:03 -0400
Date: Fri, 10 Aug 2007 11:49:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Olaf Hering <olaf@aepfle.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include linux/types.h in if_fddi.h
In-Reply-To: <20070809175307.GA10114@aepfle.de>
Message-ID: <Pine.LNX.4.64N.0708101144570.1469@blysk.ds.pg.gda.pl>
References: <20070809145511.GA8244@aepfle.de> <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl>
 <20070809173835.GA10094@aepfle.de> <20070809175307.GA10114@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Olaf Hering wrote:

> glibc includes asm/types.h, not linux/types.h. So changing the package
> to netinet/if_fddi.h does not fix anything.
> 
> Please dont drop it.
> Or should all glibc includes be changed from asm/types.h to linux/types.h?

 Well, it looks like we have changed the rules at one point, so it is up 
to us to fix the things up.  Even if the glibc maintainers are persuaded 
to accept a change (which I might try to do), older versions are already 
out there and people may still want to use it for one reason or another 
(including myself -- I am not ready to move on with glibc and will have to 
stick to version 2.4 for several months yet).

  Maciej
