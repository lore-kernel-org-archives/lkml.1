Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZBEG3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZBEG3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZBEG3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:29:12 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:4579 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZBEG3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gAWC7YR4BfNNNGNVC3r9FNWNaZ7U7TBd08hEY1valvemNbgZyUm5IViHQQwC1v3vYi
         70uz4W/SyW4t6XJ3INWCEUX1Ud7Y29lwMrctXpmICq/RZCSuqQLxTo6YfTUNYzkTBkjR
         ERQw97sKvTB8MlYxmAj/TaHfh2P/fy9nl2zSQ=
Message-ID: <498A8738.9050200@gmail.com>
Date: Thu, 05 Feb 2009 15:29:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen: setup percpu data pointers
References: <49876BD3.5070804@goop.org>
In-Reply-To: <49876BD3.5070804@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> We need to access percpu data fairly early, so set up the percpu
> registers as soon as possible.  We only need to load the appropriate
> segment register.  We already have a GDT, but its hard to change it
> early because we need to manipulate the pagetable to do so, and that
> hasn't been set up yet.
> 
> Also, set the kernel stack when bringing up secondary CPUs.  If we
> don't they all end up sharing the same stack...
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/enlighten.c |   16 ++++++++++++++++
> arch/x86/xen/smp.c       |    7 ++++++-
> arch/x86/xen/xen-ops.h   |    2 ++
> 3 files changed, 24 insertions(+), 1 deletion(-)

Applied 1-3 to #tj-percpu with trivial modification on #2 (will reply
to the message).

Thanks.

-- 
tejun
