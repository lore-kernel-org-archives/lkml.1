Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYIKGfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYIKGfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 02:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYIKGfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 02:35:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYIKGfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 02:35:37 -0400
Date: Thu, 11 Sep 2008 08:35:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sheng Yang <sheng.yang@intel.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 0/2] Clean up for MSR_IA32_FEATURE_CONTROL
Message-ID: <20080911063523.GA27877@elte.hu>
References: <1221100432-9511-1-git-send-email-sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221100432-9511-1-git-send-email-sheng.yang@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sheng Yang <sheng.yang@intel.com> wrote:

> Hi, Ingo
> 
> Here is some follow up clean up for "Move VMX MSRs to msr-index.h". 
> After discussion with Avi, I found it's more proper to move 
> MSR_IA32_FEATURE_CONTROL bits to msr-index.h as well.
> 
> But I got a little puzzle about where to accept these patches. I 
> suppose these can be picked up by tip then go with kvm when it merge 
> upstream? The main problem is macro name changed to keep consistent 
> style.

there's a few changes pending for that file:

  earth4:~/tip> gll linus.. include/asm-x86/msr-index.h
  315a655: x86: move VMX MSRs to msr-index.h
  77ef50a: x86: consolidate header guards

so i guess best is to put 315a655 into kvm.git as well and do these 
changes there. The header-guard changes should not cause significant 
merge trouble.

	Ingo
