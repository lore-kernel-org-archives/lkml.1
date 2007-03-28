Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbXC1Wna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbXC1Wna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXC1Wna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:43:30 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:32946 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933931AbXC1Wn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:43:29 -0400
Message-ID: <460AFD7F.6050802@vmware.com>
Date: Wed, 28 Mar 2007 15:42:55 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Chris Wright <chrisw@sous-sol.org>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jeremy@goop.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328222656.GS6602@sequoia.sous-sol.org> <20070328223327.GG2986@holomorphy.com>
In-Reply-To: <20070328223327.GG2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> clone_pgd_range() for consistency?  and it seems we lost a
>> paravirt_alloc_pd_clone() in there somewhere.
>>     
>
> Yes, another reason why it shouldn't have been posted as-is. It was not
> intended to for anything more than comparative benchmarking on systems
> without graphics running on the bare metal as opposed to Xen/etc. guests.
>   

So clone_pgd_range is mostly useless now.  Originally, I intended it to 
take the part of paravirt_alloc_pd_clone.  We should probably merge the 
two into just one function, unless someone thinks clone_pgd_range is 
actually useful for something.

Zach
