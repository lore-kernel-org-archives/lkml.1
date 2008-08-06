Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbYHFUnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbYHFUnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYHFUnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:43:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40478 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYHFUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:43:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	<m1hc9yjb7x.fsf@frodo.ebiederm.org>
	<86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
Date: Wed, 06 Aug 2008 13:35:55 -0700
In-Reply-To: <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 6 Aug 2008 11:29:16 -0700")
Message-ID: <m1y739j2z8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>> My suggestion for a non-breaking path:
>> - Kill NR_IRQS in then generic code.
>>  With Alan's serial patch and my kstat patch it looks like we have
>>  the worst of that.
>
> will use Alan's patch.at first.
> already reused your patch about kstat. and move kstat_irqs to irq_desc.

Part of what I am thinking is that there should never be a patch
that does s/NR_IRQS/nr_irqs/ that is just pointless noise.

Either we need a new abstraction like for_each_irq or to update the
code to the current best practices.

Which means the patches should be uncontroversial and mergeble on their
own with no weird dependencies.

Eric
