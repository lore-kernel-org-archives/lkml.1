Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXJRNdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXJRNdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXJRNdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:33:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:60486 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXJRNdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:33:24 -0400
Message-ID: <4717607A.8070304@qumranet.com>
Date: Thu, 18 Oct 2007 15:32:42 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: mingo@elte.hu, kvm-devel@lists.sourceforge.net, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] move kvm_guest_exit() after local_irq_enable()
References: <47135D1B.1060004@bull.net> <11927135412363-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <11927135412363-git-send-email-Laurent.Vivier@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if we move
> it after local_irq_enable().
>
> http://lkml.org/lkml/2007/10/15/114
>
> To simplify s390 port, we don't clear it in account_system_time().
>
> http://lkml.org/lkml/2007/10/15/183
>   

Applied (the kvm part), and added a fat comment on the barrier.  Can you 
send a signed-off-by: line?

-- 
error compiling committee.c: too many arguments to function

