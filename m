Return-Path: <linux-kernel-owner+w=401wt.eu-S2992585AbXCBQ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992585AbXCBQ03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992581AbXCBQ03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:26:29 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:50740 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992583AbXCBQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:26:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=AMrMoRXzxmiEIIvSLGwX2Xt+/kef7bcfuJLvMt4Rak4MIfr4RJYjGDVBtLb00ec0CDL1xyDUgqdtnFYtd3Cfbqw3VoTKPdBHvYRk07ekUYodI4DFzdD1w5rD3ouEOlPHp+zqF8Tuo3+ECgeiLzWHpOBM2t4sRLLmYUYFBNLvEBU=
Date: Fri, 2 Mar 2007 16:24:59 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       abelay@novell.com, shaohua.li@intel.com, len.brown@intel.com
Subject: Re: [-mm patch] cpu_idle: fix build break
Message-ID: <20070302162459.GD12727@slug>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302144007.GC12727@slug> <20070302072428.B25965@unix-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302072428.B25965@unix-os.sc.intel.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 07:24:28AM -0800, Venkatesh Pallipadi wrote:
> On Fri, Mar 02, 2007 at 02:40:07PM +0000, Frederik Deweerdt wrote:
> > On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> > > +git-acpi-fix-cpuidle-borkage.patch
> > This attached patch might be needed too, the build breaks if
> > !CONFIG_HOTPLUG_CPU and CONFIG_CPU_IDLE
> >  
> >   CC      drivers/cpuidle/cpuidle.o
> > drivers/cpuidle/cpuidle.c: In function 'cpuidle_init':
> > drivers/cpuidle/cpuidle.c:272: erreur: 'cpuidle_cpu_notifier' undeclared (first use in this function)
> > drivers/cpuidle/cpuidle.c:272: erreur: (Each undeclared identifier is reported only once
> > drivers/cpuidle/cpuidle.c:272: erreur: for each function it appears in.)
> > make[2]: *** [drivers/cpuidle/cpuidle.o] Erreur 1
> > make[1]: *** [drivers/cpuidle] Erreur 2
> > make: *** [drivers] Erreur 2
> >
> 
> Thanks for catching this breakage. Patch below should be the proper fix.
Yep, works for me.

Regards,
Frederik
