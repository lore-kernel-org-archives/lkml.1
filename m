Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZEVTxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZEVTxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZEVTxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:53:43 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:49958 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZEVTxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:53:42 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 14:53:39 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221343.30638.lkml@morethan.org> <20090522192329.GF846@one.firstfloor.org>
In-Reply-To: <20090522192329.GF846@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221453.41895.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, Andi Kleen wrote:
> On Fri, May 22, 2009 at 01:43:27PM -0500, Michael S. Zick wrote:
> > On Fri May 22 2009, you wrote:
> > > "Michael S. Zick" <lkml@morethan.org> writes:
> > > 
> > > > Found in the bit-rot for 32-bit, x86, Uni-processor builds:
> > > 
> > > Actually uni processor should not use the lock prefix 
> > > because it doesn't need it; the only exception are some special
> > > ops used in para-virtualization which are special cased.
> > > 
> > 
> > Unless you have interrupts enabled, then you have two contexts.
> 
> Interrupts on the local CPU don't interrupt instructions, only
> inbetween.
>

Ref: http://developer.intel.com/Assets/PDF/manual/253666.pdf
Manual page: 3-590  PDF page: 638
Summary: Processors prior to P-4 can take an interrupt between
the read cycle and the write cycle. Which is why opcode 0xF0 exists.

Mike
 
> -Andi


