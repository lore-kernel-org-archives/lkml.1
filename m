Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZEVVxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZEVVxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZEVVxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:53:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbZEVVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:53:30 -0400
Date: Fri, 22 May 2009 23:59:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "Michael S. Zick" <lkml@morethan.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522215939.GI846@one.firstfloor.org>
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org> <20090522204300.GA10166@const.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522204300.GA10166@const.famille.thibault.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - You got bus master DMA in your test machine?
> 
> That's not related to the LOCK_PREFIX concern, which is about the
> processor only, not interaction with other devices.

Actually it's related to other devices; but only very few (most MMIO
doesn't support atomic cycles and is uncached anyways). But there's no driver 
for real hardware in Linux that relies on it to my knowledge.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
