Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbXHJJVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbXHJJVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXHJJVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:21:14 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1176 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbXHJJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:21:13 -0400
Date: Fri, 10 Aug 2007 10:20:06 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Softlockup detected with 2.6.23-rc2-mm1
Message-ID: <20070810092006.GA9765@shadowen.org>
References: <46BC02B9.1000307@linux.vnet.ibm.com> <20070809232504.c28a3c93.akpm@linux-foundation.org> <46BC159A.9060900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BC159A.9060900@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 01:06:58PM +0530, Kamalesh Babulal wrote:
> Andrew Morton wrote:
> >On Fri, 10 Aug 2007 11:46:25 +0530 Kamalesh Babulal 
> ><kamalesh@linux.vnet.ibm.com> wrote:
> >
> >  
> >>I get call trace, when the file system stress is run on the
> >>2.6.23-rc2-mm1 kernel on a Dual Core AMD Opteron
> >>(processor 270)
> >>
> >>============================================\BUG: spinlock bad magic on 
> >>CPU#1, fsx-linux/19721
> >>    
> >
> >Yes, sorry, mm-dirty-balancing-for-tasks.patch had a bug.  Those patches 
> >were
> >removed from 2.6.23-rc2-mm2 - please test that instead.
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >  
> I get different call trace on AMD Opteron(tm) Processor 844 machine
> , I am not sure where it is related to the same patch
> 
> =====================================================
> BUG: soft lockup - CPU#3 stuck for 11s! [pdflush:272]
> CPU 3:
> Modules linked in:
> Pid: 272, comm: pdflush Not tainted 2.6.23-rc2-mm1-autokern1 #1
> RIP: 0010:[<ffffffff8021a9c3>]  [<ffffffff8021a9c3>] 
> flush_tlb_others+0x69/0x95

Cannot be 100% sure but of the group of machines showing your original
problem one showed this form.  Dropping the patches indicated by Andrew
seemed to fix both symptoms.  So I think it is highly likely the same
thing.

-apw
