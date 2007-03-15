Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXCORdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXCORdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXCORdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:33:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:48919 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXCORdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:33:19 -0400
Subject: Re: [PATCH] BLK_DEV_IDE_CELLEB dependency fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Akira Iguchi <akira2.iguchi@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, Al Viro <viro@ftp.linux.org.uk>
In-Reply-To: <45F9588C.7020108@ru.mvista.com>
References: <200703150628.l2F6SPa3028035@toshiba.co.jp>
	 <45F9588C.7020108@ru.mvista.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 18:31:56 +0100
Message-Id: <1173979916.6861.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 17:30 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> Akira Iguchi wrote:
> 
> > It's bool and it depends on BLK_DEV_IDE
> >  => should depend on BLK_DEV_IDE=y
> 
>     Hm, why I'm seeing module_init() in the driver? :-)
> 
> > And move it to "if BLK_DEV_IDEDMA_PCI" block because it depends on 
> > BLK_DEV_IDEDMA_PCI.
> 
>     IMHO, that driver shouldn't be in drivers/ide/ppc/ then...  Why it got 
> there (the same question about PowerMac driver)?

Not sure... some reorg changes ide-pmac.c into ppc/pmac.c or such, I
don't remember who did it tho.

Ben.


