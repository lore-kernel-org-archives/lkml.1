Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbXHVJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbXHVJvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXHVJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:51:10 -0400
Received: from il.qumranet.com ([82.166.9.18]:47708 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbXHVJvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:51:09 -0400
Message-ID: <46CC0719.2080103@qumranet.com>
Date: Wed, 22 Aug 2007 12:51:21 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <1187763956.6174.48.camel@localhost.localdomain> <20070822103545.GG2642@bingen.suse.de>
In-Reply-To: <20070822103545.GG2642@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This patch also means I can kill off the emulation code in
>> drivers/lguest/core.c, which is a real relief.
>>     
>
> But would it be faster? If not or only insignificant amount I think I would 
> prefer you keep it. Hooking IO is quite intrusive because it's done
> by so many drivers.
>   

I don't see why it's intrusive -- they all use the APIs, right?


-- 
error compiling committee.c: too many arguments to function

