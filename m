Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYG0T4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYG0T4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYG0T4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:56:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54115
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757622AbYG0T4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:56:05 -0400
Date: Sun, 27 Jul 2008 12:56:04 -0700 (PDT)
Message-Id: <20080727.125604.73857337.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kkeil@suse.de
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080727182709.1dac0556@lxorguk.ukuu.org.uk>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
	<20080727182709.1dac0556@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sun, 27 Jul 2008 18:27:09 +0100

> On Mon, 28 Jul 2008 02:37:32 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > On powerpc (allyesconfig build) we get this error:
> > 
> > drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit declaration of function 'virt_to_bus'
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Can we please not merge new virt_to_bus users and instead fix the actual
> code to use the right functions?

Yes, please.

IMHO, this driver was really rushed in and that was a huge mistake.
If it had gone through linux-next we could have tidied all of this
stuff up in a less "rushed" manner.
