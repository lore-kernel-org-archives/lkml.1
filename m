Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZCKRZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZCKRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZCKRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:25:19 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34196 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZCKRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:25:18 -0400
Date: Wed, 11 Mar 2009 22:55:06 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090311172506.GC9547@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090311121007.GC13835@in.ibm.com> <Pine.LNX.4.44L0.0903111232300.2692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903111232300.2692-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:34:43PM -0400, Alan Stern wrote:
> On Wed, 11 Mar 2009, K.Prasad wrote:
> 
> > The hardware breakpoint interfaces haven't been put under any CONFIG_
> > till now, but I think we should bring them under a new config, say
> > CONFIG_HW_BREAKPOINT. It would help create a dependancy for
> > CONFIG_KSYM_TRACER too.
> 
> With these patches, ptrace is dependent on hw-breakpoint.  You can't 
> disable CONFIG_HW_BREAKPOINT without breaking ptrace.
> 
> Alan Stern
> 

Agreed. We might have to retain the old code for ptrace and put the new
implementation under #ifdef CONFIG_HW_BREAKPOINT to get them working.
What do you think?

Thanks,
K.Prasad

