Return-Path: <linux-kernel-owner+w=401wt.eu-S933780AbXCMW0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbXCMW0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXCMW0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:26:07 -0400
Received: from mx.chubb.wattle.id.au ([66.29.2.6]:3695 "EHLO
	mx.chubb.wattle.id.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbXCMW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:26:05 -0400
X-Greylist: delayed 2334 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 18:26:05 EDT
Date: Wed, 14 Mar 2007 08:46:33 +1100
Message-ID: <87hcsoakau.wl%peterc@chubb.wattle.id.au>
From: Peter Chubb <peterc@chubb.wattle.id.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>, ianw@gelato.unsw.edu.au
Cc: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       nickpiggin@yahoo.com.au, akpm@linux-foundation.org, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <45F7194B.5080705@goop.org>
References: <20070313200313.GG10459@waste.org>
	<45F706BC.7060407@goop.org>
	<20070313202125.GO10394@waste.org>
	<20070313.140722.72711732.davem@davemloft.net>
	<20070313211435.GP10394@waste.org>
	<45F7194B.5080705@goop.org>
User-Agent: Wanderlust/2.15.5 (Almost Unreal) SEMI/1.14.6 (Maruoka) FLIM/1.14.8 (Shij~) APEL/10.6 MULE XEmacs/21.4 (patch 19) (Constant Variable) (x86_64-linux-gnu)
X-Face: GgFg(Z>fx((4\32hvXq<)|jndSniCH~~$D)Ka:P@e@JR1P%Vr}EwUdfwf-4j\rUs#JR{'h#
 !]])6%Jh~b$VA|ALhnpPiHu[-x~@<"@Iv&|%R)Fq[[,(&Z'O)Q)xCqe1\M[F8#9l8~}#u$S$Rm`S9%
 \'T@`:&8>Sb*c5d'=eDYI&GF`+t[LfDH="MP5rwOO]w>ALi7'=QJHz&y&C&TE_3j!
X-SA-Exim-Connect-IP: 220.237.9.178
X-SA-Exim-Rcpt-To: jeremy@goop.org, ianw@gelato.unsw.edu.au, mpm@selenic.com, davem@davemloft.net, nickpiggin@yahoo.com.au, akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: peterc@chubb.wattle.id.au
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mx.chubb.wattle.id.au)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeremy" == Jeremy Fitzhardinge <jeremy@goop.org> writes:


Jeremy> And do the same in pte pages for actual mapped pages?  Or do
Jeremy> you think they would be too densely populated for it to be
Jeremy> worthwhile?

We've been doing some measurements on how densely clumped ptes are.
On 32-bit platforms, they're pretty dense.  On IA64, quite a bit
sparser, depending on the workload of course.  I think that's mostly because
of the larger pagesize on IA64 -- with 64k pages, you don't need very
many to map a small object.

I'm hoping IanW can give more details.
