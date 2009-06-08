Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZFHSbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZFHSbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZFHSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:31:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46692 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZFHSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:31:36 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       suresh.b.siddha@intel.com, lcm@us.ibm.com
References: <20090608173917.GA8264@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Jun 2009 11:31:30 -0700
In-Reply-To: <20090608173917.GA8264@us.ibm.com> (Gary Hade's message of "Mon\, 8 Jun 2009 10\:39\:17 -0700")
Message-ID: <m1fxea8tml.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, suresh.b.siddha@intel.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Gary Hade <garyhade@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/x86_64: warn of -EBUSY returns from __assign_irq_vector()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> Impact: helps expose unexpected issues
>
> Since we have seen one case where an unexpected -EBUSY
> return from __assign_irq_vector() was included in the
> series of events that caused a serious problem
>   re: http://lkml.org/lkml/2009/6/2/377
> we should warn to help expose similar unexpected issues
> in the future.
>
> Signed-off-by: Gary Hade <garyhade@us.ibm.com>

Gary again can you make the case that this is not a problem
with fixup_irqs?

Changing the rest of the code to match the always broken
assumptions in fixup_irqs is the tail wagging the dog.

Eric
