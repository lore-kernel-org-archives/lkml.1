Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYIHCtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYIHCtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 22:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYIHCtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 22:49:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14315 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYIHCtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 22:49:24 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Sun, 7 Sep 2008 22:49:15 -0400
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com>
In-Reply-To: <48C48467.40703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809072249.17280.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 September 2008 21:48, H. Peter Anvin wrote:
> David Sanders wrote:
> > Yes the patch you supplied (and now in Linus's tree) fixes (part) of the
> > problem. In order to get a working kernel I also need a patch for the
> > nops.h issue. I have tested and confirmed that the patch posted by Linus
> > works and finally solves the problem with virtual PC.
> >
> > Linus please apply your patch (which I quote below).
>
> No, please don't.  Instead, David, please enable CONFIG_X86_GENERIC.
>


I checked the distribution I'm using (debian) and the kernel shipped with it 
does not have  CONFIG_X86_GENERIC set.  This means _when_ they ship a 2.6.27 
kernel it won't work with Virtual PC so I won't be able to even install it.
However, with Linus's patch I am guaranteed to work for all kernels built for 
X86_32 and even for X86_64 because in that case the virtual environment will 
support the multibyte NOPs.  I need Linus's fix in order to support the 
Linux-using virtual pc community.  I don't have the resources to lobby each 
individual distribution about their kernel config.  I want it to just work.  
        David
