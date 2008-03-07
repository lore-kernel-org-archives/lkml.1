Return-Path: <linux-kernel-owner+w=401wt.eu-S1764194AbYCGPdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764194AbYCGPdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYCGPdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:33:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33301 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbYCGPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:33:16 -0500
Date: Fri, 7 Mar 2008 16:34:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080307153450.GH7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <47D15CDF.5060501@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D15CDF.5060501@keyaccess.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 04:18:55PM +0100, Rene Herman wrote:
> On 07-03-08 10:07, Andi Kleen wrote:
> 
> >it to any size needed (upto 2GB currently). The default sizing 
> >heuristics are for now the same as in the old code: by default
> >all free memory below 16MB is put into the pool (in practice that
> >is only ~8MB or so usable because the kernel is loaded there too)
> 
> Just a side-comment -- not necessarily, given CONFIG_PHYSICAL_START.

"In practice". People usually do not change that. Anyways the dma zone
will be fully compatible. If you have moved your kernel outside 
the 16MB area and there is nothing else there (normally there
is some other stuff there too) you'll get the full 16MB for the default 
compat pool.

-Andi
