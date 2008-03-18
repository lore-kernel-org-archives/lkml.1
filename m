Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYCRONH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYCRONH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 10:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYCROMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 10:12:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41056 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbYCROMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 10:12:54 -0400
Date: Tue, 18 Mar 2008 13:57:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: david@lang.hm, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080318135725.425f63df@core>
In-Reply-To: <200803180233.10156.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<alpine.DEB.1.00.0803170740440.14887@asgard.lang.hm>
	<alpine.DEB.1.00.0803171021300.17640@asgard.lang.hm>
	<200803180233.10156.phillips@phunq.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the primary server goes down then we lose exactly one interesting
> data element stored only in its memory: the ramdisk dirty map.  Though
> we could be much cleverer, the backup server will simply set its entire
> map to dirty when it takes over, and will duly sync back the entire
> ramdisk to media a few minutes later.

Assuming the 1010 has proper power isolation that makes sense and would
give you pretty much what was wanted. Especially as you can replace the
secondary server with a small system which does *nothing* but sync the
ramdisk back and so is far less likely to crash.

Does make you wonder why its not built into the violin ;)

Alan
