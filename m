Return-Path: <linux-kernel-owner+w=401wt.eu-S1763910AbXHVOmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763910AbXHVOmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbXHVOma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:42:30 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:14589 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbXHVOm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:42:29 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=dB01lX/G+/NevVROpiEIif0no8//SKbj+iXbryXnuC8JxoAhPkAwb3SZzJdVDc8uW6nMfu8aCRO9qkSKZfST1nvJuLrhwShI6EAsCs0FRA3KpOUp5rhOXfifXrrubuAF;
X-IronPort-AV: E=Sophos;i="4.19,294,1183352400"; 
   d="scan'208";a="325960682"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Date: Wed, 22 Aug 2007 09:42:01 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18F2A@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Thread-Index: AcfkbXMiD0n91I2RS1ej+8nBJ7tRMAAXJSpg
References: <46C098FD.1030601@googlemail.com> <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org> <200708202334.38261.david-b@pacbell.net> <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org>
From: <Stuart_Hayes@Dell.com>
To: <torvalds@linux-foundation.org>, <david-b@pacbell.net>
Cc: <michal.k.k.piotrowski@gmail.com>, <linux-usb-devel@lists.sourceforge.net>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <dex@dragonslave.de>
X-OriginalArrivalTime: 22 Aug 2007 14:42:26.0739 (UTC) FILETIME=[A8A6F830:01C7E4CA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 21 Aug 2007, Linus Torvalds wrote:
>> 
>> Side note: after reverting 196705c9bb I can't get the mouse to skip
>> any more on that mac mini. But since the bad behaviour wasn't 100%
>> reliable to begin with, that's not really a guarantee of anything.
>> Two out of three kids are off on camp this week, so that machine
>> probably won't be getting a lot of testing ;/
> 
> Well, my one remaining child said today that "I got so much time on
> webkinz today - yesterday the mouse locked up after five minutes". 
> 
> Apparently it hadn't had the mouse lock up at all today.
> 
> So I really do believe that that 196705c9bb commit caused problems on
> intel-only USB machines too ("ondemand" cpufreq governor, switching
> between 1.0-1.66 Ghz using acpi-cpufreq: totally bog-standard in all
> respects, in other words).   
> 
> 		Linus

If you were running 2.6.26-rc3, that's quite possibly because you didn't
have the follow-up patch that fixed my original patch... it wasn't in
2.6.26-rc3
(http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg56
523.html).  It fixed a bug with my patch that wasn't necessary with
Broadcom, but was with nVidia (and Intel, I believe).

That could definitely cause mouse lock-ups.  Sorry, that should have
occurred to me yesterday when you mentioned the problem your kids were
seeing, but it didn't for some reason.

Stuart
