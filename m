Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbXCWUni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbXCWUni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934194AbXCWUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:43:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54030 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934308AbXCWUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:35 -0400
Date: Fri, 23 Mar 2007 21:47:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070323214704.1e8d5463@lxorguk.ukuu.org.uk>
In-Reply-To: <20070323130315.7ed48121.randy.dunlap@oracle.com>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070323112411.f6a8a762.randy.dunlap@oracle.com>
	<20070323200819.4e734f4f@lxorguk.ukuu.org.uk>
	<20070323130315.7ed48121.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > What is 0x40?  can it be #defined (or enum-ed) instead of a magic
> > > value?  please?  (more of same below)
> > 
> > It's 0x40. Its a "command dependant bit" - no useful name.
> 
> dependent.  OK, thanks.

IDE is a bit like that. I'm amazed some of the command flags arent in
latin.

> Already corrected (printk types).  And putting
> 					hpa_sectors);
> on a separate line doesn't hurt readability.

Maybe

Thanks for looking over the diff.

Alan
