Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbYBKRk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbYBKRk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbYBKRkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:40:51 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19353 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbYBKRku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:40:50 -0500
Subject: Re: Latest kernel doesn't boot
From: Jason Fleischli <jason.fleischli@hp.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <47ADF34A.6010804@m3y3r.de>
References: <1202249704.47a8dfe89a99c@213.133.104.17>
	 <47A8E427.6040205@zytor.com> <47AA1633.4000309@m3y3r.de>
	 <47AA2082.4000402@zytor.com> <47AA2634.7020907@m3y3r.de>
	 <47AA2A75.80909@zytor.com>  <47ADF34A.6010804@m3y3r.de>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:42:16 -0700
Message-Id: <1202751736.28742.12.camel@charlene>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 19:39 +0100, Thomas Meyer wrote:
> H. Peter Anvin schrieb:
> > Thomas Meyer wrote:
> >> H. Peter Anvin schrieb:
> >>> Thomas Meyer wrote:
> >>>>
> >>>> I can not revert the commit 
> >>>> e429795c68d3001ecae74f6465420c9f043b0ece. it gave me errors.
> >>>> but i'm also not sure what could be wrong with this commit!
> >>>>
> >>>> my first idea was that the commit 
> >>>> "[2215e69d2cf5024647f9a034807990590d25dd4e] x86 boot: use E820 
> >>>> memory map on EFI 32 platform" is the offender, because the macbook 
> >>>> pro doesn't provide a e820 memory map at all. but bisect showed 
> >>>> that i'm wrong here?!
> >>>>
> >>>
> >>> ELILO is expected to convert the memory map from EFI to e820 format.
> >> I'm using elilo-3.6-ia32.efi provided at the elilo homepage.  i 
> >> wasn't able to create a working efi toolchain :-(
> >> Does elilo-3.6 already do the converting of the memory map, or not?
> >
> > Don't know.
> 3.6 doesn't do the mapping in ia32/system.c create_boot_params().
> 3.8 does.
> 
> The problem is, that i wasn't able to produce a working elilo.efi files 
> with my gentoo toolchain. the files elilo-3.8.efi provided by the elilo 
> project also doesn't work (gives a load error from the efi runtime).
> 
> So i guess i'm stuck here.
> 
> It should be noted somewhere that with Huangs patches, elilo version 3.8 
> is needed.
> 
The release notes with elilo3.7 beta (first integration of Intel EFI 2
patches) does cover this, as well as the toolchain changes required to
build it. fyi

-Jason

