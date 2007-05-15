Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbXEOW0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbXEOW0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbXEOW0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:26:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48794 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbXEOW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:26:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464A334B.7070400@s5r6.in-berlin.de>
Date: Wed, 16 May 2007 00:25:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] missing mm.h in fw-ohci
References: <E1Ho2oc-0003TB-AX@ZenIV.linux.org.uk>
In-Reply-To: <E1Ho2oc-0003TB-AX@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote at lkml:
> need it for page_private(), not all targets have it pulled indirectly
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/firewire/fw-ohci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
> index 1f5c704..c17342d 100644
> --- a/drivers/firewire/fw-ohci.c
> +++ b/drivers/firewire/fw-ohci.c
> @@ -26,6 +26,7 @@
>  #include <linux/delay.h>
>  #include <linux/poll.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/mm.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/semaphore.h>

I will prepare a batch FireWire updates in a few days and include it
then in the unlikely event that it wasn't committed before then.
-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/
