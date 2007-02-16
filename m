Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbXBPRcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbXBPRcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932602AbXBPRcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:32:46 -0500
Received: from gw.goop.org ([64.81.55.164]:53002 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbXBPRcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:32:45 -0500
Message-ID: <45D5EABB.5090909@goop.org>
Date: Fri, 16 Feb 2007 09:32:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 04/21] Xen-paravirt: ===================================================================
References: <20070216022449.739760547@goop.org> <20070216022530.755967483@goop.org> <20070216091207.GA28196@muc.de>
In-Reply-To: <20070216091207.GA28196@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Subject? description?
>
>
> On Thu, Feb 15, 2007 at 06:24:53PM -0800, Jeremy Fitzhardinge wrote:
>   
>> -static void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
>> +static void vmi_set_pte_present(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
>>     
>
> And what good is that change anyways? unsigned long is the usual style
> for addresses.
There was a fair amount of inconsistency.  In this case, u32 was being
used for existing functions dealing with addresses, and I propagated it
through.  I can switch it all back to unsigned long if you'd prefer.

    J
