Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbYA2Ti4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbYA2Ti4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYA2Tik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:38:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53302 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752839AbYA2Tii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:38:38 -0500
Date: Tue, 29 Jan 2008 19:34:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Richard Heck <rgheck@bobjweil.com>, Gene Heskett <gene.heskett@gmail.com>,
       Zan Lynx <zlynx@acm.org>, Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-ID: <20080129193403.62fe95e8@core>
In-Reply-To: <alpine.LNX.1.00.0801291354240.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com>
	<1201539043.31293.7.camel@zem>
	<1201540830.6526.19.camel@localhost>
	<200801281230.32910.gene.heskett@gmail.com>
	<alpine.LNX.1.00.0801281248190.13593@iabervon.org>
	<479E1D9E.3000900@bobjweil.com>
	<20080129121201.2f727f5f@core>
	<alpine.LNX.1.00.0801291202550.13593@iabervon.org>
	<20080129184613.16846ae5@core>
	<alpine.LNX.1.00.0801291354240.13593@iabervon.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've seen a lot of verbosity out of SCSI messages, but I haven't seen a 
> straightforward interpretation of the problem in there. It's all 
> information useful for debugging, not information useful for system 
> administration.

It tells you what is going on. Unfortunately that frequently requires
some basic knowledge of how to interpret the error report. Drive
interface behaviour simply doesn't boil down to a fault light on the
dashboard or a "tighten the cable". For most common fault types you'll
get errors most administrators should find meaningful - like "Media error"

> On the other hand, bringing the system down because a device is 
> misbehaving is a poor idea. I've personally recovered most of the data off 

Hence we have RAID and SATA hotplug.

Alan
