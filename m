Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZFWIFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZFWIFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZFWIFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:05:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:49477 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZFWIFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="701691924"
Date: Tue, 23 Jun 2009 16:02:25 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623160225.1ebb5540@feng-desktop>
In-Reply-To: <20090623080047.GE6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
	<b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
	<20090623072811.GB6397@elte.hu>
	<20090623154724.08a51ea3@feng-desktop>
	<20090623080047.GE6397@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 16:00:47 +0800
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Feng Tang <feng.tang@intel.com> wrote:
> 
> > For these arch_early_ioremap/arch_early_iounmap API, do you mean 
> > we should put it in a sfi.h under "asm" folder? The reason we put 
> > it here is to give a arch independent API declaration here and let 
> > each arch implement its own func.
> 
> Yeah, i'd suggest to create a new early-remap.h and early-remap.c 
> kind of file to collect the existing bits for that. It's a bit ugly 
> (not really the fault of SFI - these are pre-existing facilities) 
> and might need some love - we better move it apart so that the light 
> of attention shines on it.
> 
> What's the target merge of the SFI stuff, 2.6.31?

AFAIK, Len's target is for 2.6.32

Thanks,
Feng

> 
> 	Ingo
