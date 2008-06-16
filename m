Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYFPTLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYFPTLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYFPTLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:11:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55092 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbYFPTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:11:43 -0400
Date: Mon, 16 Jun 2008 19:53:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Jackson <pj@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-ID: <20080616195340.7d0a56a8@lxorguk.ukuu.org.uk>
In-Reply-To: <4856AE64.7020906@zytor.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
	<20080616032457.718f4d87.pj@sgi.com>
	<1213606435.12968.14.camel@caritas-dev.intel.com>
	<48568B56.7060307@zytor.com>
	<20080616113806.2ff4c1a4.pj@sgi.com>
	<48569D62.9050107@zytor.com>
	<20080616123721.bb9195e6.pj@sgi.com>
	<86802c440806161041v5f582d4y2a65adf57451a6d9@mail.gmail.com>
	<20080616130938.527283f7.pj@sgi.com>
	<4856AE64.7020906@zytor.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 11:18:12 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Paul Jackson wrote:
> > Yinghai wrote:
> >> like to see to make reserve_ebda_region() more smart like the old
> >> way when andi introduced ebda_size... instead of reserve 0x9000 to
> >> 0x100000 all the way.
> > 
> > Looking back at some older kernels, that code seems to have setup an
> > ebda region only if there was a non-zero real mode pointer at 0x40E.
> > 
> > This is rather different than always setting up such a region.
> > 
> 
> Well, sort of.  Only some very old systems will not have had one.
> 
> 0x40E contains the pointer to the EBDA; this basically tests for the 
> existence of an EBDA at all.

I'd disagree with the "very old". Machines without EBDA go right up to
the AMD Athlon era and maybe beyond that. My old dual Athlon box has no
EBDA.

Alan
