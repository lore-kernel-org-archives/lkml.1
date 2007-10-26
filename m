Return-Path: <linux-kernel-owner+w=401wt.eu-S1763502AbXJZCQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502AbXJZCQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763532AbXJZCPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:15:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:57240 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763525AbXJZCPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:15:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="358735477"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <4720FE38.3050802@zytor.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	 <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	 <20071025095639.22f6cad0@laptopd505.fenrus.org>
	 <4720CCBC.1050700@zytor.com>	<m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>
	 <4720D797.1020903@zytor.com> <m1tzof3wbk.fsf@ebiederm.dsl.xmission.com>
	 <4720FE38.3050802@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 10:14:33 +0800
Message-Id: <1193364873.23935.248.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 02:11:42.0908 (UTC) FILETIME=[8D498FC0:01C81775]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 13:36 -0700, H. Peter Anvin wrote:
> Eric W. Biederman wrote:
> >>>
> >> Ying claimed that GOP requires EFI runtime services.  Is that not true?
> > 
> > None of the EFI framebuffer patches that I saw used EFI runtime services.
> > 
> 
> Ying, could you please clarify this situation?
> 
> (Eric: do note that there are two EFI framebuffer standard, UGA and GOP. 
>   Apparently UGA is obsolete and we have always been at war with GOP at 
> the moment.)

EFI framebuffer doesn't depend on EFI runtime service. It only depends
on kernel boot parameters (screen_info).

Best Regards,
Huang Ying
