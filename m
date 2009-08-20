Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZHTHdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZHTHdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZHTHdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:33:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33767 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZHTHdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:33:23 -0400
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m163cjhwa4.fsf@fess.ebiederm.org>
	<m1skfnggrb.fsf@fess.ebiederm.org>
	<7b6bb4a50908200010h1c60d007p4fa017fd97c87c19@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 20 Aug 2009 00:33:17 -0700
In-Reply-To: <7b6bb4a50908200010h1c60d007p4fa017fd97c87c19@mail.gmail.com> (Xiaotian Feng's message of "Thu\, 20 Aug 2009 15\:10\:53 +0800")
Message-ID: <m1ocqbgcsi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: xtfeng@gmail.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Xiaotian Feng <xtfeng@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer  dereference at 0000000000000008
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng <xtfeng@gmail.com> writes:

> On Thu, Aug 20, 2009 at 2:07 PM, Eric W. Biederman <ebiederm@xmission.com>
> wrote:
>
>
>     ebiederm@xmission.com (Eric W. Biederman) writes:
>
>     > I'm not certain who I should route this too, but I just had 2.6.31-rc6
>     > fall over on me.  I don't know how reproducible this will be but
>     > I have a full crash dump if someone is interested in looking into this.
>
>     Looks like I was wrong.  This is appears trivial to reproduce,
>     I have just reproduced it two more times in a row.  I think
>     the problem is pty related.
>
>     I was looking into a change in behavior on 2.6.31-rc6 where
>     data was being lost, and it appears one variant of my test program
>     kills the kernel.
>
>     The following program run as an unprivileged user causes a kernel
>     panic in about a minute:
>
>     aka
>
>     while :; do ./KernelTtyTest ; done
>
>
> oops.... It panics my x86_64 machine.....

I guess I forgot to mention that detail.  Thanks for confirming this
bug isn't just me.

Eric
