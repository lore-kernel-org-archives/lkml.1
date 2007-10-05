Return-Path: <linux-kernel-owner+w=401wt.eu-S1764636AbXJEXYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764636AbXJEXYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759634AbXJEXYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:24:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54004 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756768AbXJEXYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:24:34 -0400
Date: Sat, 6 Oct 2007 00:29:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [code] Unlimited partitions, a try
Message-ID: <20071006002919.0b32c8b9@the-village.bc.nu>
In-Reply-To: <4706B6A8.2060800@zytor.com>
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>
	<4706B6A8.2060800@zytor.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 15:11:52 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Jan Engelhardt wrote:
> > 15 partitions (at least for sd_mod devices) are too few.
> 
> Now when we have 20-bit minors, can't we simply recycle some of the 
> higher bits for additional partitions, across the board?  63 partitions 
> seem to have been sufficient; at least I haven't heard anyone complain 
> about that for 15 years.

This was proposed ages ago. Al Viro vetoed sparse minors and it has been
stuck this way ever since. If you have > 15 partitions use device mapper
for it. I'd prefer it fixed but its arguable that device mapper is the
right way to punt all our partitioning to userspace


Alan
