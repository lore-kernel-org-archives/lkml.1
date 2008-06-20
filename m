Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYFTUtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYFTUtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbYFTUln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:41:43 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:46151 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbYFTUlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:41:42 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
CC: Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jun 2008 20:40:39 +0000
Subject: RE: [WATCHDOG] v2.6.26 hpwdt.c fixes
Thread-Topic: [WATCHDOG] v2.6.26 hpwdt.c fixes
Thread-Index: AcjTDCO6/kd4TX7mRoOjMgKtIjInzwACbFXQ
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC1491BFC32890B@GVW1091EXB.americas.hpqcorp.net>
References: <20080618194917.GC2741@infomag.infomag.iguana.be>
 <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
 <20080620190538.GA30161@redhat.com>
 <alpine.LFD.1.10.0806201226420.3167@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806201226420.3167@woody.linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is correct. Linus' patch has fixed the issue on both 32 and 64 bit ProLiant platforms.


Tom

-----Original Message-----
From: Linus Torvalds [mailto:torvalds@linux-foundation.org]
Sent: Friday, June 20, 2008 2:30 PM
To: Dave Jones
Cc: Wim Van Sebroeck; Andrew Morton; LKML; Mingarelli, Thomas
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes



On Fri, 20 Jun 2008, Dave Jones wrote:
>
> FWIW, we coincidentally got the below oops reported yesterday.
> This was against 2.6.25.4, but this doesn't seem related to the NMI path,
> so probably unfixed ?

This could be fixed by my patch - you're running in 32-bit, so it's using
the "asmcall" thing in detection.

I committed my first (hackier, but simpler) patch that was tested by some
people on both 32-bit and apparently 64-bit too. It *may* fix this.

                Linus
