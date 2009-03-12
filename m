Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZCLStZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZCLStZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZCLStQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:49:16 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:49745 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZCLStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:49:16 -0400
X-Greylist: delayed 3621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 14:49:15 EDT
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: David Newall <davidn@davidnewall.com>
Subject: Re: I just got got another Oops
Date: Thu, 12 Mar 2009 13:48:43 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7; KDE/4.2.0; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903120133.11583.gene.heskett@gmail.com>
 <49B8C98D.3020309@davidnewall.com>
In-reply-to: <49B8C98D.3020309@davidnewall.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903121348.43477.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, David Newall wrote:
>Gene Heskett wrote:
>> Mar 12 01:15:01 coyote xinetd[2583]: START: amanda pid=8970
>> from=::ffff:192.168.71.3 Mar 12 01:16:21 coyote kernel: [10353.910914]
>> BUG: unable to handle kernel NULL pointer dereference at 00000006 Mar 12
>> 01:16:21 coyote kernel: [10353.910921] IP: [<c046520b>]
>> get_page_from_freelist+0x24b/0x4c0 Mar 12 01:16:21 coyote kernel:
>> [10353.910929] *pdpt = 0000000000b38001 *pde = 0000000000000000 Mar 12
>> 01:16:21 coyote kernel: [10353.910934] Oops: 0000 [#1] PREEMPT SMP
>
>I think there must be a zone at 0x0.  Try adding
>
>		if (!zone) goto try_next_zone;
>
>
>in mm/page_alloc.c, (near line 1469), before
>
>		if (NUMA_BUILD && zlc_active &&

Rebooted to the above now, still scratching head though.  Specifically, 
setroubleshoot will not return anything but a null for any 'service' command.  
In fact, none of the selinux stuff is running ANAICT.  Did we break other 
stuff?

Thanks David.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I think that I shall never see
A billboard lovely as a tree.
Indeed, unless the billboards fall
I'll never see a tree at all.
		-- Ogden Nash

