Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZDNT1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZDNT1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZDNT1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:27:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:31402 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZDNT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:27:34 -0400
Subject: Re: Out-of-order writing by disk drives
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090414185058.GZ14687@one.firstfloor.org>
References: <87r5zv72cl.fsf@basil.nowhere.org>
	 <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at>
	 <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca>
	 <20090414175433.GY14687@one.firstfloor.org>
	 <49E4D16C.7030809@msgid.tls.msk.ru>
	 <20090414185058.GZ14687@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 15:27:06 -0400
Message-Id: <1239737226.28321.22.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49E4E38F.0145:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 20:50 +0200, Andi Kleen wrote:
> On Tue, Apr 14, 2009 at 10:09:48PM +0400, Michael Tokarev wrote:
> > Andi Kleen wrote:
> > []
> > >Where I see it as a problem is with virtualization; LVM seems to be the
> > >most sane way to manage file systems for lots of VMs and you likely
> > >want barriers there too.
> > 
> > Virtualisation is the best fit for partitionable raid1 arrays.
> > It is, in fact, what we have here -- I tested LVM but rejected
> > it because of this very issue - it does not support barriers.
> 
> It does now as of 2.6.29, as long as you only have a single
> underlying device and use dm linear.

Eric Sandeen noticed this is actually still broken:

http://lkml.org/lkml/2009/3/23/360

-chris


