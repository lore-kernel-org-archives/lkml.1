Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZGMOxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZGMOxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZGMOxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:53:08 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:57662
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756053AbZGMOxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:53:07 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432R98dN1805Mzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KMQ6O8-04-GBA-01
Date: Mon, 13 Jul 2009 16:52:56 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20090713145256.GI19087@amd.com>
References: <20090710162848.GA26862@elte.hu>
 <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Jul 2009 14:52:57.0272 (UTC) FILETIME=[9BEBEB80:01CA03C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 12:06:23PM -0700, Linus Torvalds wrote:
> What am I missing (apart from the fact that all those variables are 
> horribly badly named)?
> 
> Also, the tests make no sense. That's not how you are supposed to check 
> for overlap to begin with.

The tests made sense in my brain when I wrote that function ;-) My code
checked for possible overlap scenarios. I havn't thought about doing it
much much simpler...

> 
> Isn't it easier to test for _not_ overlapping?
> 
> 	/* range1 is fully before range2 */
> 	(end1 <= start2 || 
> 	/* range1 is fully after range2 */
> 	start1 >= end2)

... by checking for non-overlap and negating the result. But now I know
better :-)

	Joerg


