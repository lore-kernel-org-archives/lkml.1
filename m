Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXC3G4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXC3G4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 02:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXC3G4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 02:56:47 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:40559 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbXC3G4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 02:56:46 -0400
Date: Fri, 30 Mar 2007 08:56:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] check for mem in slab
Message-ID: <20070330065641.GA8365@osiris.boeblingen.de.ibm.com>
References: <20070329160434.GA10265@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329160434.GA10265@cvg>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> in file mm/slab.c and routine kmem_cache_init() I found there
> is no checking for allocated memory on line:
> 
> 	/* 4) Replace the bootstrap head arrays */
> 	{
> 		struct array_cache *ptr;
> 
> 		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
> 
> --> no check for ptr == NULL <--
[...]
> is that OK? or it's a bug?

It's ok. If that allocation fails your machine won't come up anyway.
