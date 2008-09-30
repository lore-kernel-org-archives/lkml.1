Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbYI3Et2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbYI3Et2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 00:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYI3EtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 00:49:20 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34983 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYI3EtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 00:49:19 -0400
Date: Tue, 30 Sep 2008 10:13:20 +0530
From: Chirag Jog <chirag@linux.vnet.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, dvhltc@us.ibm.com,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: [BUG][PPC64] BUG in 2.6.26.5-rt9 causing Hang
Message-ID: <20080930044320.GA4685@linux.vnet.ibm.com>
Reply-To: Chirag Jog <chirag@linux.vnet.ibm.com>
Mail-Followup-To: Gregory Haskins <ghaskins@novell.com>,
	linux-rt-users <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, dvhltc@us.ibm.com,
	Dinakar Guniguntala <dino@in.ibm.com>
References: <20080925123235.GA27916@linux.vnet.ibm.com> <48E1460A.5000504@novell.com> <48E14A00.7060105@novell.com> <48E14FE1.7040507@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48E14FE1.7040507@novell.com>
Organization: IBM LTC
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,
* Gregory Haskins <ghaskins@novell.com> [2008-09-29 18:00:01]:

> Gregory Haskins wrote:
> > Gregory Haskins wrote:
> >   
> >> Hi Chirag
> >>
> >> Chirag Jog wrote:
> >>   
> >>     
> >>> Hi Gregory,
> >>> We see the following BUG followed by a hang on the latest kernel 2.6.26.5-rt9 on a Power6 blade (PPC64)
> >>> It is easily recreated by running the async_handler or sbrk_mutex (realtime tests from ltp) tests.
> >>>   
> >>>     
> >>>       
> >> Call me an LTP newbie, but where can I get the sbrk_mutex/async_handler
> >> tests.
> >>     
> > Ok, I figured out this part.  I needed a newer version of the .rpm from
> > a different repo.  However, both async_handler and sbrk_mutex seem to
> > segfault for me.  Hmm
> >   
> 
> Thanks to help from Darren I got around this issue.  Unfortunately both
> tests pass so I cannot reproduce this issue, nor do I see the problem
> via code inspection.  Ill keep digging but I am currently at a loss.  I
> may need to send you some diagnostic patches to find this, if that is ok
> with you Chirag?
This particular bug is not producible on the x86 boxes, i have access
to. Only on ppc64.
Please send the diagnostic patches across. 
I'll try them out! :)

-- 
-Thanks,Chirag
