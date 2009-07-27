Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbZG0EUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbZG0EUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 00:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZG0EUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 00:20:34 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:44094 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZG0EUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 00:20:33 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13841] 2.6.31-rc4 boot failure
Date: Mon, 27 Jul 2009 00:20:22 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30.2; KDE/4.2.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.olB.EHObKB@chimera>
In-reply-to: <3zAHs5O6maO.A.olB.EHObKB@chimera>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907270020.23019.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.30.  Please verify if it still should be listed and let me know
>(either way).
>
Yes.  I have nuked the odd stuff in my rc.local file, and rebuilt this kernel 
with several mods that I thought might be related, but it is still failing in 
the same manner.  The error messages (apparently from lp:, but long after cups 
has been started) do NOT make it to the messages log file either, so its 
totally blown up at that point.

Note, that this is a regression from 2.6 31-rc3, which works fine.  So the 
thing shouldn't be that hard to find.  But in looking over the changelog, 
nothing obviously reaches out and grabs me.

I'm not really equipt to do a bisect here either, my git from F10 is at least 
2 versions old now.  And I'm crippled by a way too small /boot partition which 
can't hold more than 12-14 kernels.  The disk partitioning tool in F10 is 
nothing short of fscking broken IMO. But fedora isn't interested in that 
either, cuz its existed since at least Fedora 2.  Here, fedora is on its way 
out, 64 bit mandriva sure looks nice.  And DiskDrake Just Works(TM).

Thanks Rafael, I thought it was being ignored.
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13841
>Subject		: 2.6.31-rc4 boot failure
>Submitter	: Gene Heskett <gene.heskett@verizon.net>
>Date		: 2009-07-23 14:12 (4 days old)
>References	: http://marc.info/?l=linux-kernel&m=124835839019906&w=4
>
>
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
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

All laws are simulations of reality.
		-- John C. Lilly

