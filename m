Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZDNSsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZDNSsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbZDNSsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:48:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33238 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZDNSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:48:08 -0400
Date: Tue, 14 Apr 2009 20:50:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, Mark Lord <lkml@rtr.ca>,
       Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090414185058.GZ14687@one.firstfloor.org>
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca> <20090414175433.GY14687@one.firstfloor.org> <49E4D16C.7030809@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4D16C.7030809@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:09:48PM +0400, Michael Tokarev wrote:
> Andi Kleen wrote:
> []
> >Where I see it as a problem is with virtualization; LVM seems to be the
> >most sane way to manage file systems for lots of VMs and you likely
> >want barriers there too.
> 
> Virtualisation is the best fit for partitionable raid1 arrays.
> It is, in fact, what we have here -- I tested LVM but rejected
> it because of this very issue - it does not support barriers.

It does now as of 2.6.29, as long as you only have a single
underlying device and use dm linear.

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
