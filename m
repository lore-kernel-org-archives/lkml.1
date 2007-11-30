Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbXK3M40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbXK3M40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXK3M4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:56:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33910 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbXK3M4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:56:07 -0500
Date: Fri, 30 Nov 2007 18:39:03 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       skumar@linux.vnet.ibm.com, menage@google.com,
       torvalds@linux-foundation.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: cpu accounting controller (V2)
Message-ID: <20071130130903.GA30772@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <20071113074805.GA13499@linux.vnet.ibm.com> <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com> <20071129191737.GH5681@linux.vnet.ibm.com> <20071129113035.bbdf35db.akpm@linux-foundation.org> <20071129201833.GA18023@linux.vnet.ibm.com> <20071130124225.GM5681@linux.vnet.ibm.com> <20071130123513.GA16690@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130123513.GA16690@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 01:35:13PM +0100, Ingo Molnar wrote:
> * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> 
> > Here's V2 of the cpu acccounting controller patch, which makes 
> > accounting scale better on SMP systems by splitting the usage counter 
> > to be per-cpu.
> 
> thanks, applied. But you dont seem to have incorporated all of the 
> review feedback from Andrew. (such as making cpuacct_subsys static)

cpuacct_subsys can't be made static, as I have pointed out at
http://marc.info/?l=linux-kernel&m=119636730930886. Other than that,
AFAICS, rest of Andrew's comments have been taken care of. If there are any 
remaining that I have over-looked, I had be happy to fix them.

-- 
Regards,
vatsa
