Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYHHXnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYHHXnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYHHXnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:43:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53639 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYHHXnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:43:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	<489CC684.8060607@zytor.com>
	<86802c440808081526j3e04c845m99582c20b79196ca@mail.gmail.com>
Date: Fri, 08 Aug 2008 16:40:09 -0700
In-Reply-To: <86802c440808081526j3e04c845m99582c20b79196ca@mail.gmail.com>
	(Yinghai Lu's message of "Fri, 8 Aug 2008 15:26:13 -0700")
Message-ID: <m14p5vyt2e.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1219]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Fri, Aug 8, 2008 at 3:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>>
>>> based on tip/master
>>>
>>> to do:
>>>   so dyn irq_desc is done, and ready to:
>>>   make create_irq to get irq according to bus/dev/func/vector
>>>
>>
>> Hm... I tried to check this in as a separate topic branch, but it conflicts
>> against both linus and against tip:x86/core, which are the branches we
>> usually base topic branches on.
>
> Ingo said, I only need to work on tip/master, and you guys will sort it out.
> Eric's NR_IRQS patch for 2.6.27 is not in tip yet. --- Andrew picked up already
>
> maybe i need put eric's patch before alan's patch in next sending...

Yes.  Let's see if we can get that regression fix in there for 2.6.27...

Eric

