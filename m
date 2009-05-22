Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZEVUnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZEVUnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbZEVUnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:43:03 -0400
Received: from solo.fdn.fr ([80.67.169.19]:43684 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbZEVUnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:43:03 -0400
Date: Fri, 22 May 2009 22:43:00 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522204300.GA10166@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Michael S. Zick" <lkml@morethan.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905221532.43775.lkml@morethan.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick, le Fri 22 May 2009 15:32:41 -0500, a écrit :
> On Fri May 22 2009, Samuel Thibault wrote:
> > Michael S. Zick, le Fri 22 May 2009 14:53:39 -0500, a écrit :
> > > Ref: http://developer.intel.com/Assets/PDF/manual/253666.pdf
> > > Manual page: 3-590  PDF page: 638
> > > Summary: Processors prior to P-4 can take an interrupt between
> > > the read cycle and the write cycle. Which is why opcode 0xF0 exists.
> > 
> > Where do you see page 638/639 talking about interrupts?  It talks about
> > multi-processor machines.
> 
> No - it talks about "exclusive memory access"

Right, that's still not interrupts.

> - You got bus master DMA in your test machine?

That's not related to the LOCK_PREFIX concern, which is about the
processor only, not interaction with other devices.

> Look people, I just reported what I found from testing - 

What did you test, precisely?

Samuel
