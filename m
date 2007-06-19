Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXFSQtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXFSQtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXFSQs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:48:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44463 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbXFSQsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:48:55 -0400
Date: Tue, 19 Jun 2007 11:48:54 -0500
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Stuart_Hayes@Dell.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070619164854.GR5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com> <DFEF91B22ED07447AB6AA4B237F913F9B18A05@ausx3mpc125.aus.amer.dell.com> <4677E30B.4020101@ru.mvista.com> <20070619150502.GO5836@austin.ibm.com> <4677FFF1.2010308@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4677FFF1.2010308@ru.mvista.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 08:10:25PM +0400, Sergei Shtylyov wrote:
> 
> >I'm thinking that trying to debug libata is a better idea, rather than
> >investing time in ide, right?  Although at the moment, libata works even 
> >less; see other email.
> 
>    Which makes me think this really is some *hardware* issue.

There are two distinct issues.
-- libata locks up in partition table read on an hpt366+old maxtor disk
   that has ben working fine for many years with old ide driver. (It
   still works fine when I boot to the alternate ide-based kernel).

-- ide driver locks up on hpt366+new maxtor disk under heavy 
   i/o load. I was able to copy 60GB from old to new disk without a
   problem; however, raid reconstruction locks it up, maybe after 5-15
   seconds.

   This probably is "hardware related"; its something that the new 
   hard drive does. Given that its being sold at a big discount, it
   may even be that the sellers know that this is a crappy disk. :-)

   All I want is some way of resetting the disk, and continuing on.

I'm stalled in debugging; I'm not sue what I'm looking for.

--linas


