Return-Path: <linux-kernel-owner+w=401wt.eu-S941070AbXHIRid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941070AbXHIRid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbXHIRiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:38:18 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36564 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764975AbXHIRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:38:17 -0400
Date: Thu, 9 Aug 2007 19:38:35 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include linux/types.h in if_fddi.h
Message-ID: <20070809173835.GA10094@aepfle.de>
References: <20070809145511.GA8244@aepfle.de> <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, Maciej W. Rozycki wrote:

> On Thu, 9 Aug 2007, Olaf Hering wrote:
> 
> > include/linux/if_fddi.h is an exported header.
> > It uses __be16. Include linux/types.h to get this prototype.
> 
>  Please note that for userland it does not matter.  With glibc you should 
> include <netinet/if_fddi.h> which does the necessary bits before including 
> <linux/if_fddi.h>.  Any other C library should likely take a similar 
> approach.

Ok, I will update the failing package.

Please drop the patch.
