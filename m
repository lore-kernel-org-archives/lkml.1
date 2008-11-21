Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYKUTry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYKUTry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbYKUTri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:47:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:60778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289AbYKUTrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:47:37 -0500
Date: Fri, 21 Nov 2008 11:02:29 -0800
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, k.gantzke@meilhaus.de
Subject: Re: linux-next-20081120 - staging - meilhaus driver build fails
Message-ID: <20081121190229.GD31017@suse.de>
References: <20081120212907.efc2276b.sfr@canb.auug.org.au> <20081120161645.GA4821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120161645.GA4821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 09:46:45PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
>  next-20081120 kernel randconfig on x86_64 box fails, while !CONFIG_MODULES
> 
> drivers/staging/meilhaus/memain.c: In function 'me_probe_pci':
> drivers/staging/meilhaus/memain.c:425: error: implicit declaration of function '__symbol_get'
> drivers/staging/meilhaus/memain.c:425: warning: cast to pointer from integer of different size
> drivers/staging/meilhaus/memain.c:433: warning: cast to pointer from integer of different size
> drivers/staging/meilhaus/memain.c:453: error: implicit declaration of function '__symbol_put'
> make[3]: *** [drivers/staging/meilhaus/memain.o] Error 1
> 
> the driver uses __symbol_get and __symbol_put instead of marco's symbol_get and symbol_put, 
> I have only build tested the patch.

Ick, the code shouldn't be doing any of this :(

I'll work on fixing this up, thanks for pointing it out.

greg k-h
