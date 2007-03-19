Return-Path: <linux-kernel-owner+w=401wt.eu-S1030395AbXCSRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395AbXCSRtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030404AbXCSRtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:49:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:57631 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030395AbXCSRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:49:21 -0400
Message-ID: <45FECD20.1040700@qumranet.com>
Date: Mon, 19 Mar 2007 19:49:20 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FAA39C.9050705@us.ibm.com> <20070316150145.GB8525@osiris.boeblingen.de.ibm.com> <45FD1778.6030602@argo.co.il> <20070319154311.GB8331@osiris.boeblingen.de.ibm.com> <45FEB431.8030504@qumranet.com>
In-Reply-To: <45FEB431.8030504@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> So the plan is:
> - get the /dev/kvm ABI into 2.6.22
> - implement smp
> - add another arch
> - move to a syscall based interface in parallel; userspace should work 
> with both
> - deprecate the old ABI and external modules.

I would also like to add using arbitrary vmas as guest memory (and 
paging guest memory) to that list.

-- 
error compiling committee.c: too many arguments to function

