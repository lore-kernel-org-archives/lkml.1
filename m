Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZETIj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZETIj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZETIjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:39:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57097 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbZETIjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:39:00 -0400
Message-ID: <4A13C199.5020400@redhat.com>
Date: Wed, 20 May 2009 11:38:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com>	 <200905071000.14038.mark.langsdorf@amd.com>	 <200905081203.55484.mark.langsdorf@amd.com>	 <200905191356.37071.mark.langsdorf@amd.com> <1242806386.26820.549.camel@twins>
In-Reply-To: <1242806386.26820.549.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> That said, I still thoroughly dislike this whole approach.
>   

Can you explain why?  We have a thread that has detected that it's 
spinning.  Keeping on spinning is a waste of cpu time.  Why not let 
something else use the cpu?

-- 
error compiling committee.c: too many arguments to function

