Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXLLNhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXLLNhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXLLNgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:36:52 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:60452 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXLLNgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:36:51 -0500
Date: Wed, 12 Dec 2007 14:36:41 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/47] Minor fixes to mm/fault.c for CRIS.
Message-ID: <20071212133641.GD3689@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com> <1cafe3040d64fbc0094c804d0840a282f71644e0.1196848533.git.jesper.nilsson@axis.com> <20071212031713.a7e42829.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212031713.a7e42829.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 03:17:13AM -0800, Andrew Morton wrote:
> On Fri, 30 Nov 2007 13:59:57 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > @@ -360,7 +247,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
> >  	up_read(&mm->mmap_sem);
> >  	printk("VM: killing process %s\n", tsk->comm);
> >  	if (user_mode(regs))
> > -		do_group_exit(SIGKILL);
> > +		do_exit(SIGKILL);
> 
> Is this change correct?

No, good catch, that's a change since we last imported to the internal tree.

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
