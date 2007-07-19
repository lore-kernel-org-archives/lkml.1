Return-Path: <linux-kernel-owner+w=401wt.eu-S938105AbXGSSbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938105AbXGSSbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbXGSSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:31:37 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:46759 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413AbXGSSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:31:36 -0400
Date: Thu, 19 Jul 2007 11:31:29 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] Change softlockup trigger limit using a kernel parameter
Message-ID: <20070719183129.GB20298@localdomain>
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org> <20070719054121.GA15074@localdomain> <20070718230907.741ae56c.akpm@linux-foundation.org> <20070719091142.GA28723@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719091142.GA28723@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:11:42AM +0200, Ingo Molnar wrote:
>
>* Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> > +softlockup_thresh:
>> > +
>> > +This value can be used to lower the softlockup tolerance
>> > +threshold. The default threshold is 10s.  If a cpu is locked up
>> > +for 10s, the kernel complains.  Valid values are 1-10s.
>> > +
>> 
>> neato.
>
>please make sure this is applied after the softlockup watchdog patches i 
>already did. (in particular the cleanup patch, which this could interact 
>with)
>
>also, i think the valid threshold should be between 1 and 60 seconds i 
>think.

60 seconds!  Is that not a pretty high threshold?  The reason for lowering
the tolerance threshold from 10s is to catch bugs early in lab environments,
but why do we need to raise the tolerance thresh beyond 10s?

Thanks,
Kiran
