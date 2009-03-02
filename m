Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZCBRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZCBRRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZCBRRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:17:45 -0500
Received: from bu3sch.de ([62.75.166.246]:54629 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZCBRRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:17:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for March 2 (wireless/b43)
Date: Mon, 2 Mar 2009 18:17:12 +0100
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
References: <20090302182217.90ca3356.sfr@canb.auug.org.au> <49AC0FAB.6000604@oracle.com>
In-Reply-To: <49AC0FAB.6000604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021817.12441.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 17:56:11 Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090227:
> > 
> > Undropped trees:
> > 	wireless
> 
> when CONFIG_SSB_DRIVER_PCICORE=n:
> 
>         if ((bus->bustype == SSB_BUSTYPE_PCI) &&
>             (bus->pcicore.dev->id.revision <= 10))
>                 hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */
> 
> ==>
> drivers/net/wireless/b43/main.c:4182: error: 'struct ssb_pcicore' has no member named 'dev'
> 
> 
> 
> 

I'll send a fix asap.

-- 
Greetings, Michael.
