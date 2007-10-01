Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbXJAJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbXJAJ5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbXJAJ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:57:35 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42936 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXJAJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:57:35 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 1 Oct 2007 05:55:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: roel <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] removes array_size duplicates
In-Reply-To: <Pine.LNX.4.64.0710010546340.15688@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0710010553420.30185@localhost.localdomain>
References: <46FC33E1.8010309@tiscali.nl> <20071001022653.40bd5714.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0710010546340.15688@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Robert P. J. Day wrote:

...
> among other things, one of the creepy issues here is the definition in
> include/linux/netfilter/xt_sctp.h of the macro:
>
> ...
> #define SCTP_CHUNKMAP_COPY(destmap, srcmap)                     \
>         do {                                                    \
>                 int i;                                          \
>                 for (i = 0; i < ELEMCOUNT(chunkmap); i++)       \
                                            ^^^^^^^^
                                            srcmap??

>                         destmap[i] = srcmap[i];                 \
>         } while (0)
> ...
>

whoops, i take it back ... isn't this just a flat-out error, where the
macro should be written with the correction above?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
