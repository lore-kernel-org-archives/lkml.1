Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZEVUcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZEVUcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZEVUcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:32:45 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:49210 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZEVUco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:32:44 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 15:32:41 -0500
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr>
In-Reply-To: <20090522200536.GZ10166@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905221532.43775.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, Samuel Thibault wrote:
> Michael S. Zick, le Fri 22 May 2009 14:53:39 -0500, a écrit :
> > Ref: http://developer.intel.com/Assets/PDF/manual/253666.pdf
> > Manual page: 3-590  PDF page: 638
> > Summary: Processors prior to P-4 can take an interrupt between
> > the read cycle and the write cycle. Which is why opcode 0xF0 exists.
> 
> Where do you see page 638/639 talking about interrupts?  It talks about
> multi-processor machines.
> 

No - it talks about "exclusive memory access" - You got bus master DMA
in your test machine? You also have an older than P-4 single processor?

Look people, I just reported what I found from testing - 
Please don't shoot the messanger.

If it: "Does not make a difference" then it "Should not make a difference"
but it does, try it yourself.  Its safe (if LOCK_PREFIX is in the proper
places) - the machine will ignore the opcode if is recent enough to not
need it - just trust the cpu's micro-code.

Mike
> Samuel
> 
> 


