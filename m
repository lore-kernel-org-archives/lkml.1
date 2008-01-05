Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYAECQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYAECQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 21:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYAECQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 21:16:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754624AbYAECQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 21:16:30 -0500
Date: Sat, 5 Jan 2008 02:14:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Querying the bios from booted linux kernel?
Message-ID: <20080105021449.2af7a429@lxorguk.ukuu.org.uk>
In-Reply-To: <477ED3B5.7070009@zytor.com>
References: <200801041913.54030.gene.heskett@gmail.com>
	<477ED3B5.7070009@zytor.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately, it is not trivial to produce a mapping from EDD data to 
> real-life disks.  Your best bet is if the disks have an MBR signature, 

Untrue for all but the very earliest EDD. True for our kernel support
which wants improving some day

> in which case the EDD code will capture those; you can then correlate 
> them to real disks.

EDD 1 provides the I/O base of each BIOS device so you can cross corelate
at least each IDE device with the BIOS identifier. EDD 3 provides paths
in multiple forms including PCI identifiers which serve the same purpose.

Unfortunately our EDD boot code doesn't capture the right bits in all
these cases.
