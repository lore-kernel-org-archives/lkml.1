Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYCOVSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYCOVSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYCOVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:18:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35892 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752632AbYCOVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:18:11 -0400
Date: Sat, 15 Mar 2008 20:56:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Daniel Phillips <phillips@phunq.net>,
       David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315205617.58aa8965@the-village.bc.nu>
In-Reply-To: <20080315205950.GA13012@1wt.eu>
References: <200803092346.17556.phillips@phunq.net>
	<200803122314.18244.phillips@phunq.net>
	<20080313132211.6af855b3@the-village.bc.nu>
	<200803131214.40321.phillips@phunq.net>
	<20080315205950.GA13012@1wt.eu>
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

> RAID controllers do not have half a terabyte of RAM. Also, you are always
> invited to choose between speed (write back) and reliability (write through).

The write back ones are also battery backed properly, and will switched
to write through (flushing out the cache) on the first sniff of a low
battery signal.

The decent ones (the kind used in serious business) also let you swap the
battery backed RAM module to another card in the event of a failure of a
card so you can complete recovery.
