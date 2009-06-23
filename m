Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZFWIBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZFWIBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZFWIBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:01:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZFWIBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:01:15 -0400
Date: Tue, 23 Jun 2009 10:00:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Feng Tang <feng.tang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623080047.GE6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com> <20090623072811.GB6397@elte.hu> <20090623154724.08a51ea3@feng-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623154724.08a51ea3@feng-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> For these arch_early_ioremap/arch_early_iounmap API, do you mean 
> we should put it in a sfi.h under "asm" folder? The reason we put 
> it here is to give a arch independent API declaration here and let 
> each arch implement its own func.

Yeah, i'd suggest to create a new early-remap.h and early-remap.c 
kind of file to collect the existing bits for that. It's a bit ugly 
(not really the fault of SFI - these are pre-existing facilities) 
and might need some love - we better move it apart so that the light 
of attention shines on it.

What's the target merge of the SFI stuff, 2.6.31?

	Ingo
