Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZKHLPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZKHLPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZKHLPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:15:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZKHLPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:15:21 -0500
Date: Sun, 8 Nov 2009 12:15:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Xiaotian Feng <dfeng@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] x86: fix error return sequence in __ioremap_caller
Message-ID: <20091108111506.GL11372@elte.hu>
References: <20091104105149.GC13194@elte.hu>
 <1257389031-20429-1-git-send-email-dfeng@redhat.com>
 <1257466996.4394.312.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257466996.4394.312.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Wed, 2009-11-04 at 18:43 -0800, Xiaotian Feng wrote:
> > kernel missed to free memtype if get_vm_area_caller failed in __ioremap_caller.
> > This patch introduces error path to fix this and cleanup the repetitive error
> > return sequence.  
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Thanks Xiaotian.

Thanks guys - queued it up for Linus.

	Ingo
