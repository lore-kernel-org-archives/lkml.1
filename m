Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZDQTrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZDQTrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZDQTrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:47:09 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1455 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZDQTrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:47:07 -0400
Date: Fri, 17 Apr 2009 21:46:46 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <andi@firstfloor.org>,
       Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090417194646.GC10554@vanheusden.com>
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4CA75.902@rtr.ca>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Apr 18 21:15:00 CEST 2009
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> A full listing of what devices do and don't support barriers would
>> be likely very long. You would actually need to list down to hard disks.
>>
>> A common problem is barriers over LVM. Since 2.6.29 they work
>> with a single device (and if the underlying device supports it) with  
>> dm linear, but not in any other LVM setup.
> ..
>
> Does anyone else here find this rather peculiar?
> The folks who actually care about barriers the most
> (apart from kernel developers) are probably enterprise users.
> And who is most likely to be using RAID and LVM,
> where barriers generally don't work at all ?

What about iSCSI? Does it support barriers?


Folkert van Heusden

-- 
MultiTail cok yonlu kullanimli bir program, loglari okumak, verilen
kommandolari yerine getirebilen. Filter, renk verme, merge, 'diff-
view', vs.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
