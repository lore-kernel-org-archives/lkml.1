Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0BIR3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab0BIR3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:29:10 -0500
Date: Tue, 9 Feb 2010 18:28:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
Message-ID: <20100209172807.GA19529@redhat.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com> <20100203230817.E6529AA@magilla.sf.frob.com> <1265315329.2768.167.camel@sbs-t61.sc.intel.com> <20100204205543.E1D11E7@magilla.sf.frob.com> <1265321114.2768.256.camel@sbs-t61.sc.intel.com> <4B6B47A1.3050606@zytor.com> <20100205211515.9805FE7@magilla.sf.frob.com> <1265405954.2812.89.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265405954.2812.89.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay!

On 02/05, Suresh Siddha wrote:
>
> On Fri, 2010-02-05 at 13:15 -0800, Roland McGrath wrote:
>
> > (OTOH, my suggestion requires a whole extra 5 lines of code or so
> > in compat_sys_ptrace because the indirection in the ABI is sensitive to
> > userland word size.)  But I don't feel strongly about the particulars of
> > the ptrace API addition, just that it be generic to cover any regset and
> > not be prone to implicit buffer-size miscommunications.  I'll leave it to
> > whatever Oleg wants to implement.
>
> Ok. I will split the previous patch in to two patches and re-post it. I
> can help Oleg with reviewing and testing the generic implementation
> whenever it is ready.

OK, I'll try to do this "asap", this generic implementation looks easy.

Except, I am not sure I really understand the problem, need to read
the regset code and then re-read this thread ;)

Oleg.

