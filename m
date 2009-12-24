Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZLXPFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZLXPFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 10:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZLXPFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 10:05:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37690 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZLXPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 10:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZzWjKAZQnB6usi7MAPen/9wWCf3M+kJu4h3I80NS41x5Xcsb0CDDcCMZmMtMGNt5nU
         LrClTgUk97dN4rohQuUoS6eW69/GF5nx5AMlUIdMxWNHEMm1vpE24VE7WCpbmAtqCPKx
         ypSHrTSsGzNSQO5qdXmxTzJj7RrwSC5HA2EOE=
Date: Thu, 24 Dec 2009 18:04:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] x86, perfctr: remove unused func
	avail_to_resrv_perfctr_nmi()
Message-ID: <20091224150458.GA5143@lenovo>
References: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 01:54:47AM +0000, Naga Chumbalkar wrote:
> avail_to_resrv_perfctr_nmi() is neither EXPORT'd, nor used in the file.
> So remove it.
> 
> Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> ---
>  arch/x86/include/asm/nmi.h             |    1 -
>  arch/x86/kernel/cpu/perfctr-watchdog.c |   11 -----------
>  2 files changed, 0 insertions(+), 12 deletions(-)
> 

Hi Naga, this looks good to me! Thanks.

Is there any plans to use this routine in future
so we shouldn't touch this snippet?

	-- Cyrill
