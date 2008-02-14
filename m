Return-Path: <linux-kernel-owner+w=401wt.eu-S934043AbYBNV1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbYBNV1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764577AbYBNV0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:26:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60757 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763661AbYBNV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:26:34 -0500
Date: Thu, 14 Feb 2008 15:24:48 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Becky Bruce <becky.bruce@freescale.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respun LMB patches.
Message-ID: <20080214152448.49c69238@zod.rchland.ibm.com>
In-Reply-To: <38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
References: <20080213.170938.34536425.davem@davemloft.net>
	<38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 14:58:22 -0600
Becky Bruce <becky.bruce@freescale.com> wrote:

> 
> On Feb 13, 2008, at 7:09 PM, David Miller wrote:
> 
> >
> > I've taken into consideration the various feedback, and
> > ported the bug fix and other LMB patches posted recently
> > in an effort to keep the patch churn by others down wrt.
> > my moving of these files.
> >
> > 1) Use HAVE_LMB as suggested by Sam.
> >
> > 2) Fix potential build errors wrt. asm/prom.h dependencies.
> >
> >    My algorithm was:
> >
> >    a) If the file only included asm/lmb.h I added an include
> >       of both linux/lmb.c and asm/prom.h
> >
> >    b) If the file already includes asm/prom.h, I merely
> >       changed the asm/lmb.h to linux/lmb.h
> >
> >    Header include mimimizations can be done as followon patches.
> >
> > 3) Integrate Kumar Gala's initial region fix.
> >
> > 4) Integrate Becky Bruce's large physical addressing change,
> >    but using u64 instead of phys_addr_t.
> >
> > It's all at:
> >
> > 	master.kernel.org:/pub/scm/linux/kernel/git/davem/lmb-2.6.git
> >
> > like before.
> 
> 
> Thanks for picking up the patches from Kumar and myself and fitting  
> them into your series - this is much appreciated.  FYI, I applied the  
> entire patch series to my local tree and test-booted both mpc8641 and  
> mpc8568mds and both build and boot cleanly. I also built pasemi and  
> ebony, those build cleanly as well.

I plan on actually testing this on Ebony, Walnut, and Bamboo either
later tonight or tomorrow.  I don't expect many issues.

Dave, those above boards would cover the build of PowerPC 4xx CPU cores.
Just an FYI.

josh
