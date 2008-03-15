Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYCOVal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYCOVal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYCOVae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:30:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48760 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752155AbYCOVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:30:33 -0400
Date: Sat, 15 Mar 2008 21:08:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315210846.72bd28f4@the-village.bc.nu>
In-Reply-To: <200803151425.49592.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<20080315205950.GA13012@1wt.eu>
	<20080315205617.58aa8965@the-village.bc.nu>
	<200803151425.49592.phillips@phunq.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2008 13:25:48 -0800
Daniel Phillips <phillips@phunq.net> wrote:

> On Saturday 15 March 2008 13:56, Alan Cox wrote:
> > > RAID controllers do not have half a terabyte of RAM. Also, you are always
> > > invited to choose between speed (write back) and reliability (write through).
> > 
> > The write back ones are also battery backed properly, and will switched
> > to write through (flushing out the cache) on the first sniff of a low
> > battery signal.
> 
> In other words, exactly how ramback works.

No because you don't honour the ordering and tag boundaries as they do.

Alan
