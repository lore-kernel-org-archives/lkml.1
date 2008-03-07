Return-Path: <linux-kernel-owner+w=401wt.eu-S1764731AbYCGPa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764731AbYCGPa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYCGPaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:30:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44267 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYCGPaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:30:03 -0500
Date: Fri, 7 Mar 2008 16:31:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080307153136.GG7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <47D15CDF.5060501@keyaccess.nl> <47D15DA4.2030500@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D15DA4.2030500@keyaccess.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 04:22:12PM +0100, Rene Herman wrote:
> On 07-03-08 16:18, Rene Herman wrote:
> 
> >On 07-03-08 10:07, Andi Kleen wrote:
> >
> >>it to any size needed (upto 2GB currently). The default sizing 
> >>heuristics are for now the same as in the old code: by default
> >>all free memory below 16MB is put into the pool (in practice that
> >>is only ~8MB or so usable because the kernel is loaded there too)
> >
> >Just a side-comment -- not necessarily, given CONFIG_PHYSICAL_START.
> 
> By the way, 1/13 didn't make it to LKML.

Yes, i was told. Not sure what happened. I'm pretty sure my script
has posted it. If anybody wants it it's in
ftp://firstfloor.org/pub/ak/mask/patches/bitops

-Andi
