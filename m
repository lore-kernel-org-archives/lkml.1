Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYD3Nvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYD3Nvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYD3NvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:51:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:49178 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbYD3NvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:51:24 -0400
X-IronPort-AV: E=Sophos;i="4.25,728,1199682000"; 
   d="scan'208";a="67453462"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kallsyms: Allow kernel symbols in L1 to be found in Blackfin architecture
Date: Wed, 30 Apr 2008 09:51:43 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <cooloney@kernel.org>, pmarques@grupopie.com,
       linux-kernel@vger.kernel.org
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org> <1209119299-27894-2-git-send-email-cooloney@kernel.org> <20080429150050.72750260.akpm@linux-foundation.org>
In-Reply-To: <20080429150050.72750260.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804300951.43995.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 30 Apr 2008 13:51:11.0370 (UTC) FILETIME=[3FAFE6A0:01C8AAC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 Apr 2008 18:00, Andrew Morton pondered: 
> That's a bit grubby.  I suppose we could pretend not to have noticed,
> but this really isn't the preferred way of putting arch-specific hooks into
> arch-neutral code.
> 
> Nicer might be to add
> 
> void __weak arch_is_kernel_text(unsigned long addr)
> {
> 	return 0;
> }
> 
> with a declaration in linux/kallsyms.h and then override
> arch_is_kernel_text() in arch/blackfin/ code.

I will refactor, and send again.

-Robin
