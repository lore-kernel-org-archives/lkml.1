Return-Path: <linux-kernel-owner+w=401wt.eu-S933726AbZKYAus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbZKYAus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbZKYAus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:50:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:12387 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580AbZKYAur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:50:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,282,1257148800"; 
   d="scan'208";a="215439074"
Subject: Re: [Bug 14658] Regression in efi.c
From: Huang Ying <ying.huang@intel.com>
To: indexer <indexer@internode.on.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4B0C7BBE.3040703@internode.on.net>
References: <bug-14658-6666@http.bugzilla.kernel.org/>
	 <200911212017.nALKHLSC029634@demeter.kernel.org>
	 <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>
	 <4B09F685.2080201@internode.on.net>
	 <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>
	 <4B0A6DCA.70805@internode.on.net>  <4B0C7BBE.3040703@internode.on.net>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 08:50:43 +0800
Message-Id: <1259110243.7068.8.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, William,

On Wed, 2009-11-25 at 08:35 +0800, indexer wrote: 
> To whom it may concern
> 
> I have redone the bisect and i believe the versions i originally stated 
> were wrong. I apologise for this mistake
> 
> commit 7bd867dfb4e0357e06a3211ab2bd0e714110def3
> Author: Feng Tang <feng.tang@intel.com>
> Date:   Thu Sep 10 10:48:56 2009 +0800
> 
>     x86: Move get/set_wallclock to x86_platform_ops
>    
>     get/set_wallclock() have already a set of platform dependent
>     implementations (default, EFI, paravirt). MRST will add another
>     variant.
>    
>     Moving them to platform ops simplifies the existing code and minimizes
>     the effort to integrate new variants.

Now Legacy RTC code instead of EFI get/set_wallclock is used on x86_64.
Your test shows that before this patch, kernel can boot on your system,
but can not boot after that?

Best Regards,
Huang Ying


