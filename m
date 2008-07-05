Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbYGEAHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbYGEAHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 20:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYGEAGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 20:06:54 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:34419 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYGEAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 20:06:54 -0400
Date: Fri, 04 Jul 2008 20:06:48 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
In-reply-to: <9l5t64tlov332uf2vfqvop9hh6ctvh067v@4ax.com>
To: linux-kernel@vger.kernel.org
Message-id: <200807042006.48545.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080703173040.GB30506@mit.edu>
 <1215182557.10393.808.camel@pmac.infradead.org>
 <9l5t64tlov332uf2vfqvop9hh6ctvh067v@4ax.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2008, Grant Coady wrote:
>On Fri, 04 Jul 2008 15:42:37 +0100, David Woodhouse <dwmw2@infradead.org> 
wrote:
>>On Fri, 2008-07-04 at 16:39 +0200, Hannes Reinecke wrote:
>>> Firmware loading is just a matter of copying the file at the correct
>>> location (ie /lib/firmware) and with the name the fw loader expects.
>>> mkinitrd should do it correctly.
>>> But I wasn't aware that the tg3 has external firmware, so I doubt
>>> we have any rpm for it.
>>
>>It doesn't yet; that patch is in linux-next. The firmware is shipped as
>>part of the kernel source tree, and you currently need to run 'make
>>firmware_install' to put it in /lib/firmware, although we're looking at
>>making that easier because apparently having to run 'make
>>firmware_install' is too hard...
>
>Oh come on now -- not a case of too hard, it's a case of breaking _all_
>existing kernel build scripts.
>
1. Something in the header of this email is preventing me from replying to the 
list, all I can get is your personal address if I try, Grant.  However, kmail 
can edit the to: and cc: lists so its fixed.

2. I am intimately familiar with my own build script, and I have a handy copy of 
vim, so if the info to do the edit is available, this excuse won't hold enough 
water to measure.

>Grant.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Solipsists of the World... you are already united.
		-- Kayvan Sylvan
