Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbXDIFXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbXDIFXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXDIFXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:23:15 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:45739 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXDIFXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:23:14 -0400
Date: Mon, 09 Apr 2007 01:23:06 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <1176092356.6355.18.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704090123.08259.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <200704081357.43370.gene.heskett@gmail.com>
 <1176092356.6355.18.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Mike Galbraith wrote:
>On Sun, 2007-04-08 at 13:57 -0400, Gene Heskett wrote:
>> On Sunday 08 April 2007, Mike Galbraith wrote:
>> >On Sun, 2007-04-08 at 13:40 +0200, Mike Galbraith wrote:
>> >> On Sun, 2007-04-08 at 07:33 -0400, Gene Heskett wrote:
>> >> > That seems to be the killer loading here, building a kernel (make
>> >> > -j3) doesn't seem to lag it all that bad.  One session of gzip
>> >> > -best makes it fall plumb over though, which was a
>> >> > disappointment.
>> >>
>> >> Can you make a testcase that doesn't require amanda?
>> >
>> >Or at least send me a couple of 5 or 10 second top snapshots (which
>> > also show CPU usage of sleeping tasks) while the system is
>> > misbehaving?
>> >
>> >	-Mike
>>
>> With what monitor utility?
>
>Top.
>
>	-Mike

This may not be so informative, its almost behaving ATM.

29252 amanda    22   0  1856  572  220 R 76.4  0.1   1:07.24 gzip
29235 amanda    15   0  2992 1224  888 S  5.6  0.1   0:02.80 chunker
29500 root      18   0  2996 1164  788 S  4.0  0.1   0:02.40 tar
10459 amanda    15   0  3340 1052  832 S  3.0  0.1   0:49.04 amandad
10536 amanda    15   0  3276 1308 1004 S  2.3  0.1   0:40.92 dumper
29496 amanda    18   0  2808  472  280 S  2.0  0.0   0:01.73 sendbackup
 4057 gkrellmd  15   0 11568 1172  896 S  1.3  0.1   7:45.82 gkrellmd
29498 amanda    18   0  2396  780  656 S  1.0  0.1   0:00.60 tar
19183 root      15   0     0    0    0 S  0.7  0.0   0:01.92 pdflush

I also note with some disdain that I'm half a megabyte into swap, but I've 
had FF-2.0.0.3 busy for the last hour while amanda was trying to find a 
few cycles at the same time.  Looking at a bunch of pdf's of circuit 
boards to see if I wanna build them for my milling machine.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Fatal Error: Found MS-Windows System -> Repartitioning Disk for Linux...
