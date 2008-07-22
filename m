Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYGVExI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYGVExI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYGVEwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:52:55 -0400
Received: from ozlabs.org ([203.10.76.45]:60280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYGVEwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:52:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest.
Date: Tue, 22 Jul 2008 14:52:41 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
References: <200807221431.58991.rusty@rustcorp.com.au> <20080722143800.d392994f.sfr@canb.auug.org.au>
In-Reply-To: <20080722143800.d392994f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221452.41586.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 14:38:00 Stephen Rothwell wrote:
> Hi Rusty,
>
> On Tue, 22 Jul 2008 14:31:58 +1000 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > +/* This belongs in pgtable.h, but our includes are too much of a mess.
> > */ +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> > +#define PTE_FLAGS	_AC(0x8000000000000FFF, ULL)
>
> Just a small point:  You don't actually need the _AC() because this is
> already in a #ifndef __ASSEMBLY__ section of the file.  But better safe
> than sorry, I guess.  :-)

Ah, yes, I had them in pgtable.h before I gave up.  I'll leave it in: if 
someone wants them in asm they can now safely move it.

Thanks,
Rusty.
