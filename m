Return-Path: <linux-kernel-owner+w=401wt.eu-S965804AbXC1Xsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965804AbXC1Xsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965814AbXC1Xsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:48:41 -0400
Received: from gw.goop.org ([64.81.55.164]:49179 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965804AbXC1Xsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:48:40 -0400
Message-ID: <460AFEDA.8060303@goop.org>
Date: Wed, 28 Mar 2007 16:48:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zach Brown <zach.brown@oracle.com>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>	<20070322170122.ee2589a1.akpm@linux-foundation.org>	<b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>	<20070326201552.b8ad7dda.akpm@linux-foundation.org>	<b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com>	<3D4D126C-0B26-4B00-A2E4-68BD84555B51@oracle.com>	<20070328161420.3c8f9688.akpm@linux-foundation.org>	<3F0B1567-B32C-44F4-9B90-0737ADDACC56@oracle.com> <20070328163416.133d109a.akpm@linux-foundation.org>
In-Reply-To: <20070328163416.133d109a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 28 Mar 2007 16:21:04 -0700
> Zach Brown <zach.brown@oracle.com> wrote:
>
>   
>>> Does this look OK?
>>>       
>> Almost...
>>
>>     
>>> #ifdef CONFIG_HIGHMEM
>>> static inline void pipe_kunmap_atomic(void *addr, enum km_type type)
>>> #else	/* CONFIG_HIGHMEM */
>>> static inline void pipe_kunmap_atomic(struct page *page, enum  
>>> km_type type)
>>>       
>
> OK, I give up.  What are you telling me here?
>   

Also void *addr vs struct page *page.

    J
