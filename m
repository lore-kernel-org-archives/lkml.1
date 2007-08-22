Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbXHVKXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbXHVKXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXHVKXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:23:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:50864 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbXHVKXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:23:30 -0400
Message-ID: <46CC0EAF.3000805@qumranet.com>
Date: Wed, 22 Aug 2007 13:23:43 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <1187763956.6174.48.camel@localhost.localdomain> <20070822103545.GG2642@bingen.suse.de> <46CC0719.2080103@qumranet.com> <20070822110810.GO32640@bingen.suse.de>
In-Reply-To: <20070822110810.GO32640@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I don't see why it's intrusive -- they all use the APIs, right?
>>     
>
> Yes, but it still changes them. It might have a larger impact
> on code size for example. 
>   

Only if CONFIG_PARAVIRT is defined.  And even then, all the performance 
sensitive stuff uses mmio, no?


-- 
error compiling committee.c: too many arguments to function

