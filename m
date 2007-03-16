Return-Path: <linux-kernel-owner+w=401wt.eu-S965622AbXCPRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbXCPRAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965681AbXCPRAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:00:22 -0400
Received: from gw.goop.org ([64.81.55.164]:36854 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965622AbXCPRAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:00:20 -0400
Message-ID: <45FACD24.5080000@goop.org>
Date: Fri, 16 Mar 2007 10:00:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 23/26] Xen-paravirt_ops: Add Xen grant table support
References: <20070301232443.195603797@goop.org> <20070301232529.139074125@goop.org> <20070316085107.GC23174@elte.hu>
In-Reply-To: <20070316085107.GC23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +
>> +#ifndef __ia64__
>> +	{
>>     
>
> introduce a proper arch method instead.
>   

I'll clean out the ia64 stuff.  We can add it back properly when (if?)
the time comes.

>> +	grant_ref_t g = *private_head;
>> +	if (unlikely(g == GNTTAB_LIST_END))
>>     
>
> coding style problems.

Yup.


