Return-Path: <linux-kernel-owner+w=401wt.eu-S966188AbXHIR23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966188AbXHIR23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbXHIR2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:28:22 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4470 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbXHIR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:28:21 -0400
Date: Thu, 9 Aug 2007 17:36:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Olaf Hering <olaf@aepfle.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include linux/types.h in if_fddi.h
In-Reply-To: <20070809145511.GA8244@aepfle.de>
Message-ID: <Pine.LNX.4.64N.0708091654120.3151@blysk.ds.pg.gda.pl>
References: <20070809145511.GA8244@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Olaf Hering wrote:

> include/linux/if_fddi.h is an exported header.
> It uses __be16. Include linux/types.h to get this prototype.

 Please note that for userland it does not matter.  With glibc you should 
include <netinet/if_fddi.h> which does the necessary bits before including 
<linux/if_fddi.h>.  Any other C library should likely take a similar 
approach.

 It still seems right for Linux itself though.

  Maciej
