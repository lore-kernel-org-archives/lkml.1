Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbYGaWXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbYGaWXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYGaWXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:23:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52812 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbYGaWXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:23:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       benh <benh@kernel.crashing.org>
References: <200807291414.55479.yhlu.kernel@gmail.com>
	<200807300311.48510.yhlu.kernel@gmail.com>
	<200807301210.31511.yhlu.kernel@gmail.com>
	<200807302109.21519.yhlu.kernel@gmail.com>
	<1217541108.8157.108.camel@twins>
Date: Thu, 31 Jul 2008 15:14:57 -0700
In-Reply-To: <1217541108.8157.108.camel@twins> (Peter Zijlstra's message of
	"Thu, 31 Jul 2008 23:51:48 +0200")
Message-ID: <m1tze5zony.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Peter Zijlstra <peterz@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0059]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/3] dyn_array support #2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, 2008-07-30 at 21:09 -0700, Yinghai Lu wrote:
>> please check the patches adding dyn_array and nr_irqs #2
>
> Why can't we use a radix tree like powerpc does?

Unless I am mistaken the ppc uses the radix tree for something
different.  We don't have any architecture in the kernel to
my knowledge that doesn't use an array of irq_desc entries.

Killing the array of irq_desc entries and along with it
NR_IRQS is what needs to happen.

Eric
