Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXJYVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXJYVkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXJYVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:40:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:51280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXJYVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:40:47 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6 patch] unexport tick_nohz_get_sleep_length
Date: Thu, 25 Oct 2007 17:40:22 -0400
User-Agent: KMail/1.9.5
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20071024162422.GH30533@stusta.de> <653FFBB4508B9042B5D43DC9E18836F5018EBEF1@scsmsx415.amr.corp.intel.com> <alpine.LFD.0.9999.0710251855510.3186@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710251855510.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251740.22999.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Thursday 25 October 2007 12:56, Thomas Gleixner wrote:
> On Thu, 25 Oct 2007, Pallipadi, Venkatesh wrote:
> > >On Wed, 24 Oct 2007, Adrian Bunk wrote:
> > >
> > >> This patch removes the unused 
> > >> EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length).
> > >> 
> > >> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > >> 
> > >> ---
> > >> f7c83dfe117f4fd072b2506ae090e4145abda362 
> > >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > >> index 10a1347..5997456 100644
> > >> --- a/kernel/time/tick-sched.c
> > >> +++ b/kernel/time/tick-sched.c
> > >> @@ -320,8 +320,6 @@ ktime_t tick_nohz_get_sleep_length(void)
> > >>  	return ts->sleep_length;
> > >>  }
> > >>  
> > >> -EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length);
> > >> -
> > >
> > >Hmm, this was added to allow the cpuidle governers modular
> > >build. Seems this was changed to compiled in only.
> > >
> > >Len, Venki, is this the final decision ?
> > >
> > 
> > Yes. This was done recently for proper fallback to old ACPI policy in
> > case CPUIDLE is not selected. With that being module, falling back to
> > ACPI policy at run time makes things ugly.
> 
> Makes sense. I go ahead and nuke the export.
> 
> Thanks,
> 
> 	tglx
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
