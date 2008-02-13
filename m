Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbYBMCJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbYBMCJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYBMCJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:09:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:64715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbYBMCJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:09:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,343,1199692800"; 
   d="scan'208";a="378320529"
Subject: Re: Latest kernel doesn't boot
From: "Huang, Ying" <ying.huang@intel.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       jason.fleischli@hp.com
In-Reply-To: <47ADF34A.6010804@m3y3r.de>
References: <1202249704.47a8dfe89a99c@213.133.104.17>
	 <47A8E427.6040205@zytor.com> <47AA1633.4000309@m3y3r.de>
	 <47AA2082.4000402@zytor.com> <47AA2634.7020907@m3y3r.de>
	 <47AA2A75.80909@zytor.com>  <47ADF34A.6010804@m3y3r.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Feb 2008 10:01:58 +0800
Message-Id: <1202868118.5026.10.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 13 Feb 2008 02:01:44.0450 (UTC) FILETIME=[62049E20:01C86DE4]
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

Can you attach the error message with elilo 3.8?

> It should be noted somewhere that with Huangs patches, elilo version 3.8 
> is needed.

Yes. I will add this.

Best Regards,
Huang Ying

