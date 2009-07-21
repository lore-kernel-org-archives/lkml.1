Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZGUWSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZGUWSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZGUWSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:18:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41260 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbZGUWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:18:40 -0400
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       LKML <linux-kernel@vger.kernel.org>
References: <4A64672E.8020005@cn.fujitsu.com>
	<m1d47vnoq6.fsf@fess.ebiederm.org>
	<20090720211644.GD9060@hmsreliant.think-freely.org>
	<4A65644F.7010309@cn.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 21 Jul 2009 15:18:34 -0700
In-Reply-To: <4A65644F.7010309@cn.fujitsu.com> (Lai Jiangshan's message of "Tue\, 21 Jul 2009 14\:46\:39 +0800")
Message-ID: <m1ocrdn0hx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, brayan@yack.com.br, vgoyal@redhat.com, akpm@linux-foundation.org, nhorman@tuxdriver.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lai Jiangshan <laijs@cn.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c handler"
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan <laijs@cn.fujitsu.com> writes:

> Even I agreed your fix, I don't agreed your naming,
> For your fix, the correct naming should be:
>
> .help_msg       = "oops(C)",
> .action_msg     = "Trigger an oops"
>
> And document it:
> Sysrq-c always causes an oops by an indirect way. It'll do one of 4 things:
> 1) panic_on_oops=0, it is just kill the current task.
> 2) panic_on_oops=1, but CONFIG_KEXEC=n, just normal panic
> 3) panic_on_oops=1, CONFIG_KEXEC=y, but not enabled, just normal panic
> 4) panic_on_oops=1, CONFIG_KEXEC=y, kdump was enabled, CrashDump.


That sounds like a great way to sort out the understanding.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Could you turn that into a proper patch?


Eric
