Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbXLLHJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbXLLHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 02:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbXLLHJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 02:09:21 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:59163 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750710AbXLLHJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 02:09:20 -0500
Date: Wed, 12 Dec 2007 12:38:16 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071212070816.GA31455@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071210091501.deed38fa.randy.dunlap@oracle.com> <20071211145437.GA15617@linux.vnet.ibm.com> <20071211164319.GA14783@linux.vnet.ibm.com> <20071211170400.GA4861@suse.de> <20071211172338.GA17896@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211182015.GA22339@linux.vnet.ibm.com> <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211210653.GA6902@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 10:06:53PM +0100, Ingo Molnar wrote:
> 
> * Fortier,Vincent [Montreal] <Vincent.Fortier1@EC.GC.CA> wrote:
> 
> > > That has changed from /sys/kernel/uids/<uid>/cpu_share
> > > 
> > 
> > Here is my config.
> > 
> > Maybie I should give it a shot without CFS at all and see what 
> > happends ?
> 
> and also with CFS but without CONFIG_FAIR_GROUP_SCHED.
> 

Hi Ingo,

I am able to reproduce the oops here on my system with 2.6.22.14 +
CFS backport. I am not able to reproduce it with 2.6.22.13 + CFS
backport. I believe the CFS backport is just exposing the bug. Can't
find an obvious culprit and am looking into this issue.

Vincent, could you please confirm if you are able to reproduce this with
2.6.22.13 + CFS?

Thanks,
-- 
regards,
Dhaval
