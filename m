Return-Path: <linux-kernel-owner+w=401wt.eu-S935198AbXJPSab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198AbXJPSab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbXJPSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:30:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58062 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbXJPSaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:30:15 -0400
Date: Wed, 17 Oct 2007 00:12:04 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071016184204.GA19219@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071016091012.GB24341@elte.hu> <20071016094631.GA10649@elte.hu> <20071016180037.GC5670@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016180037.GC5670@shadowen.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 07:00:37PM +0100, Andy Whitcroft wrote:
> > ah, this is likely with the recent scheduler commits included as well, 
> > right?
> > 
> > if it's reproducable, could you try with group scheduling disabled, i.e. 
> > with:
> > 
> >   # CONFIG_FAIR_GROUP_SCHED is not set
> > 
> > as that would be the main suspect for such type of a crash.
> 
> Ok, preliminary results with this disabled seem to get us past
> kernbench.  I am rerunning with it enabled to confirm it blammo's.

Andy,
	I have got details from Kamalesh on the machine where this is 
recreatable (we couldn't recreate on other machines). Will start looking
at this tomorrow morning first thing ..

-- 
Regards,
vatsa
