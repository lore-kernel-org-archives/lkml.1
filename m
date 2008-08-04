Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYHDXar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYHDXar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYHDXaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:30:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48712 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYHDXaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:30:23 -0400
Date: Mon, 4 Aug 2008 16:30:18 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Message-ID: <20080804233018.GD30096@us.ibm.com>
References: <20080804194646.GA17390@us.ibm.com> <57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com> <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com> <20080804224533.GC30096@us.ibm.com> <57C9024A16AD2D4C97DC78E552063EA3083291DF@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3083291DF@orsmsx505.amr.corp.intel.com>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.2008 [15:53:03 -0700], Luck, Tony wrote:
> > Would you like me to test this patch on the box, to verify? It seems
> > like you were able to reproduce the non-booting kernel?
> 
> As soon as I turned on CONFIG_PRINTK_TIME=y I hit what I presume was
> the same problem.
> 
> If you have time to do so, then confirming that this is the same issue
> that you are seeing on your system would be good.

Turning off PRINTK_TIME or using your patch allows this box to boot, so
I think it is the same.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
