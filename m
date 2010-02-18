Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab0BRRXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:23:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53652 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab0BRRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:23:05 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>
	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>
	<m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>
	<4B7CAADD.2060000@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Feb 2010 09:22:45 -0800
In-Reply-To: <4B7CAADD.2060000@kernel.org> (Yinghai Lu's message of "Wed\, 17 Feb 2010 18\:50\:05 -0800")
Message-ID: <m1mxz6v4pm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/3] x86: use vector_desc instead of vector_irq
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
> of handle_irq.
> use vector_desc to reduce the calling of irq_to_desc.
>
> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc
>
> -v2: irq should be unsigned in 32bit handle_irq according to Eric
>      also reset vector_desc for lguest in setup_irq
> -v3: keep irq in x+execute_on_irq_stack() ...
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I can't spot any more problems.


Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

