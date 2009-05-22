Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZEVWIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZEVWIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZEVWIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:08:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbZEVWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:08:44 -0400
Date: Sat, 23 May 2009 00:14:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Andi Kleen <andi@firstfloor.org>, "Michael S. Zick" <lkml@morethan.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522221456.GK846@one.firstfloor.org>
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org> <20090522204300.GA10166@const.famille.thibault.fr> <20090522215939.GI846@one.firstfloor.org> <20090522220049.GD10166@const.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522220049.GD10166@const.famille.thibault.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's what I meant: AIUI, LOCK_PREFIX has always only been used for
> inter-processor interaction (atomic variables, spinlocks, etc.), not for

PCI has a locked transaction, but I don't think it's widely supported.
With normal uncached access it is also not very useful.

> processor-device interaction.

Well in Linux yes, but not architecturally in x86. That is why the CPUs
don't just nop it out with a single core (which Michael assumes they do,
but they don't)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
