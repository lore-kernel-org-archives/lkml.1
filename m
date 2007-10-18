Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbXJRMmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbXJRMmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXJRMml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:42:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:60564 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906AbXJRMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:42:41 -0400
Message-ID: <47175495.6060706@qumranet.com>
Date: Thu, 18 Oct 2007 14:41:57 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Use virtual cpu accounting if available for guest times.
References: <47135D1B.1060004@bull.net> <11926264852739-git-send-email-Laurent.Vivier@bull.net> <200710181439.10390.borntraeger@de.ibm.com>
In-Reply-To: <200710181439.10390.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> ppc and s390 offer the possibility to track process times precisely
> by looking at cpu timer on every context switch, irq, softirq etc.
> We can use that infrastructure as well for guest time accounting.
> We need to account the used time before we change the state. 
> This patch adds a call to account_system_vtime to kvm_guest_enter
> and kvm_guest exit. If CONFIG_VIRT_CPU_ACCOUNTING is not set,
> account_system_vtime is defined in hardirq.h as an empty function,
> which means this patch does not change the behaviour on other
> platforms.
>
> I compile tested this patch on x86 and function tested the patch on
> s390.
>
> Avi, please apply.
>
>   

Done.  Thanks!

-- 
error compiling committee.c: too many arguments to function

